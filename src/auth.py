"""Password hashing, opaque-token helpers, and the request ``Principal``.

Stdlib-only (no external crypto dependency), consistent with the rest of
OpenReturn. Passwords are low-entropy, so they use **scrypt** with a per-user
random salt (a slow, salted KDF); session and API tokens are high-entropy random
strings, so storing their **sha256** is sufficient (same approach as the existing
API-key table).
"""
from __future__ import annotations

import base64
import hashlib
import hmac
import secrets
from dataclasses import dataclass, field

# scrypt cost parameters — ~16 MB of memory per hash at n=2**14, r=8.
_SCRYPT_N = 1 << 14
_SCRYPT_R = 8
_SCRYPT_P = 1
_SCRYPT_MAXMEM = 64 * 1024 * 1024
_SALT_BYTES = 16
_TOKEN_BYTES = 32


def hash_password(password: str) -> str:
    """Return an encoded scrypt hash: ``scrypt$<n>$<r>$<p>$<salt_b64>$<hash_b64>``."""
    salt = secrets.token_bytes(_SALT_BYTES)
    dk = hashlib.scrypt(password.encode("utf-8"), salt=salt, n=_SCRYPT_N,
                        r=_SCRYPT_R, p=_SCRYPT_P, maxmem=_SCRYPT_MAXMEM)
    return "scrypt${}${}${}${}${}".format(
        _SCRYPT_N, _SCRYPT_R, _SCRYPT_P,
        base64.b64encode(salt).decode(), base64.b64encode(dk).decode())


def verify_password(password: str, encoded: str) -> bool:
    """Constant-time verify of ``password`` against an encoded scrypt hash.
    Returns False (never raises) on a malformed/foreign hash string."""
    try:
        scheme, n, r, p, salt_b64, hash_b64 = encoded.split("$")
        if scheme != "scrypt":
            return False
        salt = base64.b64decode(salt_b64)
        expected = base64.b64decode(hash_b64)
        dk = hashlib.scrypt(password.encode("utf-8"), salt=salt,
                            n=int(n), r=int(r), p=int(p), maxmem=_SCRYPT_MAXMEM)
    except (ValueError, TypeError):
        return False
    return hmac.compare_digest(dk, expected)


def generate_token() -> str:
    """A new opaque bearer token (session key or API key) — high-entropy."""
    return secrets.token_urlsafe(_TOKEN_BYTES)


def hash_token(raw: str) -> str:
    """The sha256 hex of a token — what is stored (tokens are high-entropy, so a
    fast hash is fine; this matches the existing api_key.key_hash scheme)."""
    return hashlib.sha256(raw.encode("utf-8")).hexdigest()


@dataclass(frozen=True)
class Principal:
    """The authenticated caller for one request: a logged-in user (via a session
    key) or a program (via an API key). ``permissions`` is the resolved set of
    permission codes the caller holds; ``rate_limit`` is requests/minute
    (-1 = unlimited). Attached by the server to the request ``headers`` so
    handlers can attribute audit entries and scope private data."""

    kind: str                              # 'user' | 'program'
    actor_id: int                          # user_id or key_id
    label: str                             # username or key name (for the audit trail)
    permissions: frozenset[str] = field(default_factory=frozenset)
    rate_limit: int = -1
    user_id: int | None = None             # set for kind == 'user'

    def has(self, permission: str) -> bool:
        return permission in self.permissions
