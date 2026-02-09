{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  # dependencies
  anyio,
  fhaviary,
  fhlmi,
  html2text,
  httpx,
  httpx-aiohttp,
  numpy,
  paper-qa-pypdf,
  pybtex,
  pydantic,
  pydantic-settings,
  rich,
  tantivy,
  tenacity,
  tiktoken,
  # optional
  paper-qa-docling,
  paper-qa-nemotron,
  paper-qa-pymupdf,
  pillow,
  qdrant-client,
  sentence-transformers,
  unstructured,
}:

buildPythonPackage (finalAttrs: {
  pname = "paper-qa";
  version = "2026.01.05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Future-House";
    repo = "paper-qa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cb/OPssQU2crONycYJnl2e56o6qwFXfrwpLZWpH88GY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    anyio
    fhaviary
    fhlmi
    html2text
    httpx
    httpx-aiohttp
    numpy
    paper-qa-pypdf
    pybtex
    pydantic
    pydantic-settings
    rich
    tantivy
    tenacity
    tiktoken
  ];

  optional-dependencies = {
    docling = [ paper-qa-docling ];
    image = [ pillow ] ++ fhlmi.optional-dependencies.image;
    local = [ sentence-transformers ];
    nemotron = [ paper-qa-nemotron ];
    office = [ unstructured ];
    pymupdf = [ paper-qa-pymupdf ];
    qdrant = [ qdrant-client ];
  };

  pythonImportsCheck = [ "paperqa" ];

  # Tests require network access and API keys
  doCheck = false;

  meta = {
    description = "LLM Chain for answering questions from documents";
    homepage = "https://github.com/Future-House/paper-qa";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "pqa";
    platforms = lib.platforms.unix;
  };
})
