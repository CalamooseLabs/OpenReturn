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
      # Fallback if package-data didn't bundle the SQL/HTML assets: copy each
      # concern's sql tree (one folder per Database subclass) plus the views.
      for d in Schema Organization Filing ReportedData ApiKey Ingest Migration Score; do
        cp -r ${./src}/database/$d/sql $out/lib/python*/site-packages/database/$d/ 2>/dev/null || true
      done
      cp -r ${./src}/router/Upload/views $out/lib/python*/site-packages/router/Upload/ 2>/dev/null || true
    }
  '';

  doCheck = false;
}
