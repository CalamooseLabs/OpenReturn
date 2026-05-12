{ pkgs ? import <nixpkgs> {} }:

pkgs.python3Packages.buildPythonApplication {
  pname = "ffapi";
  version = "0.1.0";

  src = ./.;
  format = "pyproject";

  nativeBuildInputs = with pkgs.python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with pkgs.python3Packages; [
  ];

  postInstall = ''
    find $out -name "*.sql" -o -name "*.html" | head -1 > /dev/null || {
      cp -r ${./src}/database/IRS990/*.sql $out/lib/python*/site-packages/database/IRS990/ 2>/dev/null || true
      cp -r ${./src}/router/Upload/views $out/lib/python*/site-packages/router/Upload/ 2>/dev/null || true
    }
  '';

  doCheck = false;
}
