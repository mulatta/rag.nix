{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tenacity,
  httpx,
  nest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "semanticscholar";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danielnsilva";
    repo = "semanticscholar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-02aBY4J1JAMFUXsK8FnW4r0JWO+VsUHxcZMceILsLQY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    tenacity
    httpx
    nest-asyncio
  ];

  pythonImportsCheck = [ "semanticscholar" ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Unofficial Python client library for Semantic Scholar APIs";
    homepage = "https://github.com/danielnsilva/semanticscholar";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
