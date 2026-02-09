{
  lib,
  buildPythonPackage,
  fetchPypi,
  uv-build,
  feedparser,
  bibtexparser,
  httpx,
  whenever,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyzotero";
  version = "1.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-kOxAQOWiYYK54rDqp5RUZLy09XxxCxQYwczRm7XM96c=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["uv_build>=0.8.14,<0.9.0"]' 'requires = ["uv_build>=0.8.14"]'
  '';

  build-system = [ uv-build ];

  dependencies = [
    feedparser
    bibtexparser
    httpx
    whenever
  ];

  pythonImportsCheck = [ "pyzotero" ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Python wrapper for the Zotero API";
    homepage = "https://github.com/urschrei/pyzotero";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
