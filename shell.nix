{
  pkgs,
  inputs,
}: let
  zedSettings = {
    auto_install_extensions = {
      "python" = true;
      "xml" = true;
      "sql" = true;
    };
    languages = {
      "SQL" = {
        formatter = {
          external = {
            command = "sql-formatter";
            arguments = [ "--language" "sqlite" "--fix"];
          };
        };
      };
    };
  };
  runtests = pkgs.writeShellScriptBin "runtests" ''
    PYTHONPATH=src pytest tests "''${@}"
  '';
  runserver = pkgs.writeShellScriptBin "runserver" ''
    python3 src/cli.py serve "''${@}"
  '';
  build-wiki = pkgs.writeShellScriptBin "build-wiki" ''
    # Build the wiki pages from docs/ without cloning/pushing (preview/validate).
    # Defaults --out to ./wiki-build/ when not given; forwards any extra args.
    root="$(git rev-parse --show-toplevel)"
    case " $* " in
      *" --out "*) python3 "$root/tools/build_wiki.py" "''${@}" ;;
      *)           python3 "$root/tools/build_wiki.py" --out "$root/wiki-build" "''${@}" ;;
    esac
  '';
  publish-wiki = pkgs.writeShellScriptBin "publish-wiki" ''
    set -euo pipefail
    root="$(git rev-parse --show-toplevel)"
    src="$root/docs"
    builder="$root/tools/build_wiki.py"
    # Wiki repo URL: arg 1 overrides; otherwise <origin> with any trailing slash
    # and a single .git stripped, then .wiki.git appended — correct whether or
    # not origin carried the .git suffix (a naive s/\.git$/…/ would no-op on a
    # .git-less origin and target the MAIN repo).
    if [ -n "''${1:-}" ]; then
      remote="$1"
    else
      origin="$(git -C "$root" remote get-url origin)"
      remote="$(printf '%s' "$origin" | sed -E 's#/+$##; s#\.git$##').wiki.git"
      if [ "$remote" = "$origin" ]; then
        echo "publish-wiki: refusing to run — derived wiki URL equals origin ($origin)" >&2
        exit 1
      fi
    fi

    if [ ! -f "$builder" ]; then
      echo "publish-wiki: builder not found at $builder" >&2
      exit 1
    fi
    if [ ! -d "$src" ] || ! ls "$src"/*.md >/dev/null 2>&1; then
      echo "publish-wiki: no docs pages found in $src" >&2
      exit 1
    fi

    clone="$(mktemp -d)"
    trap 'rm -rf "$clone"' EXIT
    echo "Cloning $remote ..."
    git clone --quiet "$remote" "$clone"

    # Rebuild the flat wiki from docs/: flatten nested pages, rewrite relative
    # links to wiki slugs, regenerate _Sidebar.md/_Footer.md, and validate every
    # internal link + anchor (a broken one aborts here via set -e).
    echo "Building wiki pages from docs/ ..."
    rm -f "$clone"/*.md
    python3 "$builder" --out "$clone"

    cd "$clone"
    git add -A
    if git diff --cached --quiet; then
      echo "Wiki already up to date — nothing to publish."
      exit 0
    fi
    echo "Publishing changes:"
    git diff --cached --stat
    git commit -q -m "Sync wiki from docs/"
    git push
    echo "Published wiki to $remote"
  '';
  gcommit = pkgs.writeShellScriptBin "gcommit" ''
    msg_file="GIT_COMMIT_MSG"

    if [[ ! -f "$msg_file" ]] || [[ ! -s "$msg_file" ]]; then
      echo "Error: $msg_file is missing or empty. Nothing to commit." >&2
      exit 1
    fi

    echo ""
    echo "=== Commit message (from $msg_file) ==="
    cat "$msg_file"
    echo "========================================"
    echo ""
    read -r -p "Commit with this message? [y/N] " gc_confirm
    if [[ "$gc_confirm" != "y" && "$gc_confirm" != "Y" ]]; then
      echo "Aborted — $msg_file left unchanged."
      exit 0
    fi

    git commit -F "$msg_file"
    gc_exit=$?
    if [[ $gc_exit -ne 0 ]]; then
      echo "Commit failed (exit $gc_exit). $msg_file left unchanged." >&2
      exit $gc_exit
    fi

    echo ""
    read -r -p "Tag this commit? [y/N] " gc_do_tag
    if [[ "$gc_do_tag" == "y" || "$gc_do_tag" == "Y" ]]; then
      read -r -p "Tag name (e.g. v1.2.0): " gc_tag_name
      if [[ -z "$gc_tag_name" ]]; then
        echo "No tag name given — skipping tag."
      else
        read -r -p "Tag annotation (leave blank to reuse commit message): " gc_tag_msg
        if [[ -z "$gc_tag_msg" ]]; then
          git tag -s "$gc_tag_name" -F "$msg_file"
        else
          git tag -s "$gc_tag_name" -m "$gc_tag_msg"
        fi
      fi
    fi

    # Clear the scratchpad so it is not accidentally reused
    > "$msg_file"
    echo ""
    echo "$msg_file cleared. Ready for the next commit."
  '';
in
  pkgs.mkShell {
    buildInputs = [
      (inputs.zed-editor.packages.x86_64-linux.default zedSettings)
      (pkgs.python3.withPackages (ps: [ ps.pytest ps.pytest-sugar ps.coverage ps.pytest-cov ]))
      pkgs.sql-formatter
      pkgs.ruff
      pkgs.claude-code
      gcommit
      runtests
      runserver
      build-wiki
      publish-wiki
    ];
  }
