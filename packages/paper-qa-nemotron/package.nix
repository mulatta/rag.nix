{
  lib,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  pillow,
  fhaviary,
  fhlmi,
  litellm,
  numpy,
  pypdfium2,
  tenacity,
  # src provider
  paper-qa,
}:

buildPythonPackage {
  pname = "paper-qa-nemotron";
  inherit (paper-qa) version src;
  pyproject = true;

  sourceRoot = "${paper-qa.src.name}/packages/paper-qa-nemotron";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pillow
    fhaviary
    fhlmi
    litellm
    numpy
    pypdfium2
    tenacity
    # paper-qa - circular dependency, will be satisfied at runtime
  ]
  ++ fhaviary.optional-dependencies.image;

  # Circular dependency with paper-qa - skip runtime deps check
  dontCheckRuntimeDeps = true;
  doCheck = false;

  meta = {
    inherit (paper-qa.meta) homepage maintainers;
    description = "PaperQA reader using Nvidia nemotron-parse VLM API";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}
