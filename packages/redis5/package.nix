# TODO: Remove when nixpkgs redis updates to satisfy >=5.0.0,<6.0.0
# Currently nixpkgs has redis 6.2.0, mem0ai requires <6.0.0
{
  lib,
  buildPythonPackage,
  fetchPypi,
  async-timeout,
}:

buildPythonPackage (finalAttrs: {
  pname = "redis";
  version = "5.3.1";
  format = "wheel";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-3BkJvSRmnMMbX2egOXALFuwwVxCWxfHw2dIyS/8xr5c=";
  };

  dependencies = [ async-timeout ];

  pythonImportsCheck = [ "redis" ];
  doCheck = false;

  meta = {
    description = "Python client for Redis (pinned for mem0ai compatibility)";
    homepage = "https://github.com/redis/redis-py";
    license = lib.licenses.mit;
  };
})
