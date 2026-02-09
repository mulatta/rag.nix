{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  coredis,
  fhaviary,
  limits,
  litellm,
  pydantic,
  tiktoken,
}:

buildPythonPackage rec {
  pname = "fhlmi";
  version = "0.43.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y7f2+NxV6wgrebwoYA3+LmyXIfGY7HayR0rq24xBM2k=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    coredis
    fhaviary
    limits
    litellm
    pydantic
    tiktoken
  ];

  pythonImportsCheck = [ "lmi" ];

  # Tests require network access and additional dependencies
  doCheck = false;

  meta = {
    description = "A client to provide LLM responses for FutureHouse applications";
    homepage = "https://github.com/Future-House/ldp";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
