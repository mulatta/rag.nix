{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pypdf,
  # optional
  pypdfium2,
}:

buildPythonPackage (finalAttrs: {
  pname = "paper-qa-pypdf";
  version = "2026.01.05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Future-House";
    repo = "paper-qa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cb/OPssQU2crONycYJnl2e56o6qwFXfrwpLZWpH88GY=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/paper-qa-pypdf";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pypdf
    # paper-qa - circular dependency, will be satisfied at runtime
  ];

  optional-dependencies = {
    media = [ pypdfium2 ];
  };

  # Circular dependency with paper-qa - skip runtime deps check
  dontCheckRuntimeDeps = true;
  doCheck = false;

  meta = {
    description = "PaperQA readers implemented using PyPDF";
    homepage = "https://github.com/Future-House/paper-qa";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
