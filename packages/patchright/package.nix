# Patchright Python package
# Based on playwright-python with patches for anti-detection.
# Renames the package from "playwright" to "patchright" and
# replaces the driver with a patched version from GitHub releases.
{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitMinimal,
  greenlet,
  pyee,
  python,
  setuptools,
  setuptools-scm,
  nodejs,
  callPackage,
}:
let
  patchright-driver = callPackage ./driver.nix { };
  inherit (patchright-driver) driver;
in
buildPythonPackage (finalAttrs: {
  pname = "patchright";
  version = "1.58.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gK19pjB8TDy/kK+fb4pjwlGZlUyY26p+CNxunvIMrrY=";
  };

  postPatch = ''
    # --- Rename package directory ---
    mv playwright patchright

    # --- Update internal imports (35 files, .patch impractical) ---
    find patchright -type f -name '*.py' -exec sed -i \
      -e 's/from playwright/from patchright/g' \
      -e 's/import playwright/import patchright/g' \
      -e 's/playwright\./patchright./g' {} \;

    # --- Update pyproject.toml (substituteInPlace for fail-fast) ---
    substituteInPlace pyproject.toml \
      --replace-fail 'name = "playwright"' 'name = "patchright"' \
      --replace-fail '"playwright"' '"patchright"' \
      --replace-fail 'playwright/_repo_version.py' 'patchright/_repo_version.py' \
      --replace-fail 'playwright.' 'patchright.' \
      --replace-fail 'playwright =' 'patchright ='
    sed -i \
      -e 's/requires = \["setuptools==.*", "setuptools-scm==.*", "wheel==.*", "auditwheel==.*"\]/requires = ["setuptools", "setuptools-scm", "wheel"]/' \
      -e '/description = /s/=.*/= "Undetected Python version of Playwright"/' \
      pyproject.toml

    # --- Remove setup.py (tries to download driver from CDN) ---
    rm -f setup.py

    # --- Version file ---
    echo 'version = "${finalAttrs.version}"' > patchright/_repo_version.py

    # --- Replace driver location ---
    cp ${./_driver.py} patchright/_impl/_driver.py
    substituteInPlace patchright/_impl/_driver.py \
      --replace-fail '@node@' '${lib.getExe nodejs}' \
      --replace-fail '@driver@' '${driver}/package/cli.js'

    # --- Verify rename succeeded ---
    test -d patchright/_impl || { echo "ERROR: patchright rename failed"; exit 1; }
    grep -q 'patchright' pyproject.toml || { echo "ERROR: pyproject.toml patch failed"; exit 1; }

    # --- Workaround for setuptools-scm ---
    export HOME=$(mktemp -d)
    ${gitMinimal}/bin/git init .
    ${gitMinimal}/bin/git add -A .
    ${gitMinimal}/bin/git config user.email "nixpkgs"
    ${gitMinimal}/bin/git config user.name "nixpkgs"
    ${gitMinimal}/bin/git commit -m "workaround setuptools-scm"
  '';

  build-system = [
    gitMinimal
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "greenlet"
    "pyee"
  ];

  dependencies = [
    greenlet
    pyee
  ];

  postInstall = ''
    ln -s ${driver} $out/${python.sitePackages}/patchright/driver
  '';

  doCheck = false;

  pythonImportsCheck = [ "patchright" ];

  passthru = {
    inherit driver;
    inherit (patchright-driver) browsers;
  };

  meta = {
    description = "Undetected Python version of Playwright";
    homepage = "https://github.com/Kaliiiiiiiiii-Vinyzu/patchright-python";
    changelog = "https://github.com/Kaliiiiiiiiii-Vinyzu/patchright-python/releases";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
