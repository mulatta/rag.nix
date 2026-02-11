{
  lib,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  pypdf,
  # optional
  pdfplumber,
  pillow,
  pypdfium2,
  # src provider
  paper-qa,
}:

buildPythonPackage {
  pname = "paper-qa-pypdf";
  inherit (paper-qa) version src;
  pyproject = true;

  sourceRoot = "${paper-qa.src.name}/packages/paper-qa-pypdf";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pypdf
    # paper-qa - circular dependency, will be satisfied at runtime
  ];

  optional-dependencies = {
    enhanced = [
      pdfplumber
      pillow
      pypdfium2
    ];
    media = [
      pillow
      pypdfium2
    ];
  };

  # Circular dependency with paper-qa - skip runtime deps check
  dontCheckRuntimeDeps = true;
  doCheck = false;

  meta = {
    inherit (paper-qa.meta) homepage maintainers;
    description = "PaperQA readers implemented using PyPDF";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}
