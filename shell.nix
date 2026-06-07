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
    python3 src/main.py "''${@}"
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
    ];
  }
