{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  docstring-parser,
  httpx,
  httpx-aiohttp,
  pydantic,
}:

buildPythonPackage rec {
  pname = "fhaviary";
  version = "0.32.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Future-House";
    repo = "aviary";
    tag = "v${version}";
    hash = "sha256-CRL/JrPwsAxDP+1XpO56cBc5nqIyHZX9BYfv6pMq1sQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    docstring-parser
    httpx
    httpx-aiohttp
    pydantic
  ];

  pythonImportsCheck = [ "aviary" ];

  # Tests require additional dependencies and network access
  doCheck = false;

  meta = {
    description = "Gymnasium framework for training language model agents on constructive tasks";
    homepage = "https://github.com/Future-House/aviary";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
