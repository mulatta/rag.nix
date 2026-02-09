{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pillow,
  fhaviary,
  fhlmi,
  litellm,
  numpy,
  pypdfium2,
  tenacity,
}:

buildPythonPackage (finalAttrs: {
  pname = "paper-qa-nemotron";
  version = "2026.01.05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Future-House";
    repo = "paper-qa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cb/OPssQU2crONycYJnl2e56o6qwFXfrwpLZWpH88GY=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/paper-qa-nemotron";

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
    description = "PaperQA reader using Nvidia nemotron-parse VLM API";
    homepage = "https://github.com/Future-House/paper-qa";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
