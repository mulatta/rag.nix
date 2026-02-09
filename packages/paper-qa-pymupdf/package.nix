{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pymupdf,
}:

buildPythonPackage (finalAttrs: {
  pname = "paper-qa-pymupdf";
  version = "2026.01.05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Future-House";
    repo = "paper-qa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cb/OPssQU2crONycYJnl2e56o6qwFXfrwpLZWpH88GY=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/paper-qa-pymupdf";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pymupdf
    # paper-qa - circular dependency, will be satisfied at runtime
  ];

  # Circular dependency with paper-qa - skip runtime deps check
  dontCheckRuntimeDeps = true;
  doCheck = false;

  meta = {
    description = "PaperQA readers implemented using PyMuPDF";
    homepage = "https://github.com/Future-House/paper-qa";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
