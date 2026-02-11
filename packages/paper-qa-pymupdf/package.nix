{
  lib,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  pymupdf,
  # src provider
  paper-qa,
}:

buildPythonPackage {
  pname = "paper-qa-pymupdf";
  inherit (paper-qa) version src;
  pyproject = true;

  sourceRoot = "${paper-qa.src.name}/packages/paper-qa-pymupdf";

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
    inherit (paper-qa.meta) homepage maintainers;
    description = "PaperQA readers implemented using PyMuPDF";
    license = lib.licenses.agpl3Only; # Different from paper-qa (asl20)
    platforms = lib.platforms.unix;
  };
}
