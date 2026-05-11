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
in
  pkgs.mkShell {
    buildInputs = [
      (inputs.zed-editor.packages.x86_64-linux.default zedSettings)
      pkgs.python3
      pkgs.sql-formatter
    ];
  }
