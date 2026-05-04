{
  pkgs,
  inputs,
}: let
  zedSettings = {
    auto_install_extensions = {
      "python" = true;
    };
  };
in
  pkgs.mkShell {
    buildInputs = [
      (inputs.zed-editor.packages.x86_64-linux.default zedSettings)
      pkgs.python3
    ];
  }
