{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  # dependencies
  aiofiles,
  aiohttp,
  aiosqlite,
  anyio,
  lxml,
  litellm,
  numpy,
  pillow,
  playwright,
  patchright,
  python-dotenv,
  requests,
  beautifulsoup4,
  tf-playwright-stealth,
  xxhash,
  rank-bm25,
  snowballstemmer,
  pydantic,
  pyopenssl,
  psutil,
  pyyaml,
  nltk,
  rich,
  cssselect,
  httpx,
  fake-useragent,
  click,
  chardet,
  brotli,
  humanize,
  lark,
  alphashape,
  shapely,
  # optional deps
  pypdf,
  pytorch,
  scikit-learn,
  transformers,
  tokenizers,
  sentence-transformers,
  selenium,
  # passthru
  playwright-driver,
}:

buildPythonPackage (finalAttrs: {
  pname = "crawl4ai";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unclecode";
    repo = "crawl4ai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P+bejaH3SVScNECajjozU3+o3dh8V/8V/N83yMPX2sU=";
  };

  build-system = [
    setuptools
    wheel
  ];

  postPatch = ''
    # Remove directory creation from setup.py that assumes writable HOME
    sed -i '/# Create the .crawl4ai folder/,/^    (crawl4ai_folder \/ folder).mkdir(exist_ok=True)/d' setup.py
  '';

  dependencies = [
    aiofiles
    aiohttp
    aiosqlite
    anyio
    lxml
    litellm
    numpy
    pillow
    playwright
    patchright
    python-dotenv
    requests
    beautifulsoup4
    tf-playwright-stealth
    xxhash
    rank-bm25
    snowballstemmer
    pydantic
    pyopenssl
    psutil
    pyyaml
    nltk
    rich
    cssselect
    httpx
    fake-useragent
    click
    chardet
    brotli
    humanize
    lark
    alphashape
    shapely
  ];

  optional-dependencies = {
    pdf = [ pypdf ];
    torch = [
      pytorch
      nltk
      scikit-learn
    ];
    transformer = [
      transformers
      tokenizers
      sentence-transformers
    ];
    cosine = [
      pytorch
      transformers
      nltk
      sentence-transformers
    ];
    sync = [ selenium ];
  };

  pythonRelaxDeps = [
    "lxml"
    "snowballstemmer"
    "pyOpenSSL"
  ];

  makeWrapperArgs = [
    "--set PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers}"
    "--set PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD 1"
  ];

  # Tests require network access and browser setup
  doCheck = false;

  # Skip import check as it tries to create directories in HOME
  # pythonImportsCheck = [ "crawl4ai" ];

  passthru = {
    inherit (patchright) browsers;
  };

  meta = {
    description = "Open-source LLM Friendly Web Crawler & Scraper";
    homepage = "https://github.com/unclecode/crawl4ai";
    changelog = "https://github.com/unclecode/crawl4ai/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "crwl";
  };
})
