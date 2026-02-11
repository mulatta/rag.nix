{
  lib,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  docling,
  docling-core,
  # src provider
  paper-qa,
}:

buildPythonPackage {
  pname = "paper-qa-docling";
  inherit (paper-qa) version src;
  pyproject = true;

  sourceRoot = "${paper-qa.src.name}/packages/paper-qa-docling";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    docling
    docling-core
    # paper-qa - circular dependency, will be satisfied at runtime
  ];

  # Circular dependency with paper-qa - skip runtime deps check
  dontCheckRuntimeDeps = true;
  doCheck = false;

  meta = {
    inherit (paper-qa.meta) homepage maintainers;
    description = "PaperQA readers implemented using Docling";
    license = lib.licenses.asl20;
    # Inherits platform constraints from docling-parse (wheel-based)
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
