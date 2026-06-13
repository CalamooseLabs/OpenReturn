"""Background-process helpers for `openreturn ingest --background`.

A background ingest is a double-forked daemon detached from the controlling
terminal, so it survives the SSH session that launched it. Its stdout/stderr go
to a log file and a small JSON PID file records the run (pid, source, log,
start time) so `openreturn status` can report it and `openreturn ingest --stop`
can signal it.

Stopping is *cooperative*: ``--stop`` sends SIGTERM, the handler installed here
sets a module-level flag, and the ingest loops break at the next archive
boundary and fall through to the normal finalize step (index rebuild + WAL
checkpoint). That leaves the database consistent and queryable rather than
killing the process mid-write with indexes dropped and the bulk-load pragmas
still in effect.
"""

import atexit
import json
import os
import signal
import sys
import traceback
from pathlib import Path

# PID/log files live in the current working directory — the same place the
# server, ingest, and keys commands expect OpenReturn.db (the data dir on a
# NixOS deploy). Keep them relative so each data dir tracks its own ingest.
DEFAULT_PIDFILE = "ingest.pid"
DEFAULT_LOG = "ingest.log"

_stop_requested = False


def request_stop(*_args) -> None:
    """SIGTERM handler: ask the running ingest to stop at the next safe point."""
    global _stop_requested
    _stop_requested = True


def stop_requested() -> bool:
    return _stop_requested


def install_stop_handler() -> None:
    signal.signal(signal.SIGTERM, request_stop)


# ── PID file ───────────────────────────────────────────────────────────────

def write_pidfile(path: str, info: dict) -> None:
    Path(path).write_text(json.dumps(info))


def read_pidfile(path: str) -> dict | None:
    try:
        return json.loads(Path(path).read_text())
    except (OSError, ValueError):
        return None


def remove_pidfile(path: str) -> None:
    try:
        Path(path).unlink()
    except OSError:  # pragma: no cover — best-effort cleanup
        pass


def pid_alive(pid: int) -> bool:
    """True if a process with ``pid`` exists (signal 0 probes without sending)."""
    try:
        os.kill(pid, 0)
    except ProcessLookupError:
        return False
    except PermissionError:  # exists but owned by another user
        return True
    return True


def acquire_spawn_lock(pidfile: str = DEFAULT_PIDFILE) -> str | None:
    """Atomically claim the right to start a daemon for ``pidfile``.

    Closes the time-of-check/time-of-use window between ``running_daemon``
    returning None and the daemon writing its PID file: two near-simultaneous
    ``--background`` starts would otherwise both pass the check and both spawn,
    leaving two daemons fighting over the exclusive DB lock. Returns the lock
    path on success, or None if another start/daemon already holds it. The
    caller releases it (``release_spawn_lock``) only after the daemon's real PID
    file is written and visible, so a second start sees either the lock or the
    PID file.
    """
    lock = pidfile + ".lock"
    try:
        fd = os.open(lock, os.O_CREAT | os.O_EXCL | os.O_WRONLY, 0o644)
    except FileExistsError:
        return None
    os.close(fd)
    return lock


def release_spawn_lock(lock: str | None) -> None:
    if lock:
        remove_pidfile(lock)


def running_daemon(pidfile: str = DEFAULT_PIDFILE) -> dict | None:
    """Return the PID-file dict if it points at a live process, else None.

    A PID file left behind by a crashed run is stale; it is removed so callers
    treat the absence of a live daemon uniformly.
    """
    info = read_pidfile(pidfile)
    if not info:
        return None
    pid = info.get("pid")
    if isinstance(pid, int) and pid_alive(pid):
        return info
    remove_pidfile(pidfile)
    return None


# ── Daemonize ────────────────────────────────────────────────────────────────

def _redirect_std(log_path: str) -> None:
    sys.stdout.flush()
    sys.stderr.flush()
    log_fd = os.open(log_path, os.O_WRONLY | os.O_CREAT | os.O_APPEND, 0o644)
    devnull = os.open(os.devnull, os.O_RDONLY)
    os.dup2(devnull, 0)
    os.dup2(log_fd, 1)
    os.dup2(log_fd, 2)
    os.close(devnull)
    if log_fd > 2:
        os.close(log_fd)
    # Rebind the Python-level streams onto the log fds. dup2 only redirects the
    # OS file descriptors; sys.stdout/err keep writing to whatever object they
    # already wrapped (which may have been replaced by the caller, e.g. under
    # test capture), so without this the ingest's output never reaches the log.
    # Line-buffered (buffering=1) so `tail -f ingest.log` shows progress live.
    sys.stdout = os.fdopen(1, "w", buffering=1, closefd=False)
    sys.stderr = os.fdopen(2, "w", buffering=1, closefd=False)


def spawn_background(run, log_path: str, pidfile: str, meta: dict) -> int:
    """Fork a detached daemon that runs ``run()`` and return its PID.

    Uses the classic double-fork so the daemon is reparented to init and cannot
    reacquire a controlling terminal. The grandchild writes the PID file and
    reports its PID to the original process over a pipe, so the returned value
    is accurate and the PID file already exists by the time this returns. In the
    daemon, ``run()`` is executed and the process exits; this never returns
    there.
    """
    r, w = os.pipe()
    pid = os.fork()
    if pid > 0:
        # Original process: read the daemon PID, reap the short-lived child.
        os.close(w)
        data = os.read(r, 64)
        os.close(r)
        os.waitpid(pid, 0)
        return int(data.strip() or 0)

    # First child — detach into a new session, then fork the real daemon.
    os.close(r)
    try:
        os.setsid()
        if os.fork() > 0:
            os._exit(0)

        # Grandchild (the daemon).
        _redirect_std(log_path)
        daemon_pid = os.getpid()
        write_pidfile(pidfile, {**meta, "pid": daemon_pid})
        os.write(w, str(daemon_pid).encode())
        os.close(w)

        install_stop_handler()
        atexit.register(remove_pidfile, pidfile)
        rc = 0
        try:
            rc = run() or 0
        except SystemExit as exc:
            rc = exc.code if isinstance(exc.code, int) else (0 if exc.code is None else 1)
        except BaseException:  # noqa: BLE001 — log anything before exiting
            traceback.print_exc()
            rc = 1
        finally:
            remove_pidfile(pidfile)
            # os._exit (used so the forked daemon never runs the parent's
            # atexit/cleanup) skips stdio buffer flushing — do it explicitly or
            # the log file loses all the ingest's buffered output.
            sys.stdout.flush()
            sys.stderr.flush()
        os._exit(rc)
    except BaseException:  # pragma: no cover — fork/setsid failure in child
        traceback.print_exc()
        os._exit(1)
