{ pkgs ? import <nixpkgs> {} }:

pkgs.python3Packages.buildPythonApplication {
  pname = "openreturn";
  version = "0.1.0a1";

  src = ./.;
  format = "pyproject";

  nativeBuildInputs = with pkgs.python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with pkgs.python3Packages; [
    # SQLCipher binding — enables optional at-rest DB encryption when a key is
    # provided via DB_SECRET_KEY / DB_SECRET_KEY_FILE. Without it the app falls
    # back to an unencrypted database (with a warning).
    sqlcipher3
  ];

  postInstall = ''
    find $out -name "*.sql" -o -name "*.html" | head -1 > /dev/null || {
      cp -r ${./src}/database/IRS990/sql $out/lib/python*/site-packages/database/IRS990/ 2>/dev/null || true
      cp -r ${./src}/database/Score/sql $out/lib/python*/site-packages/database/Score/ 2>/dev/null || true
      cp -r ${./src}/router/Upload/views $out/lib/python*/site-packages/router/Upload/ 2>/dev/null || true
    }
  '';

  doCheck = false;
}
