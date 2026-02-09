# Patchright driver - patched playwright driver from GitHub releases
{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  linkFarm,
  callPackage,
  nodejs,
  # Linux dependencies
  glib,
  nss,
  nspr,
  atk,
  at-spi2-atk,
  libdrm,
  libgbm,
  xorg,
  expat,
  libxkbcommon,
  alsa-lib,
  cairo,
  cups,
  dbus,
  pango,
  libgcc,
}:
let
  inherit (stdenv.hostPlatform) system;

  throwSystem = throw "Unsupported system: ${system}";

  suffix =
    {
      x86_64-linux = "linux";
      aarch64-linux = "linux-arm64";
      x86_64-darwin = "mac";
      aarch64-darwin = "mac-arm64";
    }
    .${system} or throwSystem;

  version = "1.58.2";

  patchright-driver-linux = stdenv.mkDerivation {
    pname = "patchright-driver";
    inherit version;

    src = fetchzip {
      url = "https://github.com/Kaliiiiiiiiii-Vinyzu/patchright/releases/download/v${version}/playwright-${version}-${suffix}.zip";
      hash =
        {
          x86_64-linux = "sha256-jQ/+4IBfwzbMgL77bfTtbMNgx7WAh2zP5obV6UNacBQ=";
          aarch64-linux = "sha256-eQqCuA4jf+0h2IJc8CNR4HnscolbGIFAgdJSzNrpZ8c=";
        }
        .${system} or throwSystem;
    };

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = [
      glib
      nss
      nspr
      atk
      at-spi2-atk
      libdrm
      libgbm
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      xorg.libxcb
      expat
      libxkbcommon
      alsa-lib
      cairo
      cups
      dbus
      pango
      libgcc
      stdenv.cc.cc.lib
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R . $out/

      runHook postInstall
    '';

    meta = {
      description = "Patchright driver (patched Playwright)";
      homepage = "https://github.com/Kaliiiiiiiiii-Vinyzu/patchright";
      license = lib.licenses.asl20;
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
  };

  patchright-driver-darwin = fetchzip {
    url = "https://github.com/Kaliiiiiiiiii-Vinyzu/patchright/releases/download/v${version}/playwright-${version}-${suffix}.zip";
    stripRoot = false;
    hash =
      {
        x86_64-darwin = "sha256-O1D2SIp6iuWKMmGG2YMcVpvWqp6n3GPl9dJJtLfxshY=";
        aarch64-darwin = "sha256-UYFCzwoIim/7FF+YpBPLzxoPs2V8Y/MQVxm8n/SEsII=";
      }
      .${system} or throwSystem;
  };

  driver =
    {
      x86_64-linux = patchright-driver-linux;
      aarch64-linux = patchright-driver-linux;
      x86_64-darwin = patchright-driver-darwin;
      aarch64-darwin = patchright-driver-darwin;
    }
    .${system} or throwSystem;

  chromium = callPackage ./chromium.nix { };

  # Chromium revision from patchright 1.58.2
  chromiumRevision = "1208";

  browsers = linkFarm "patchright-browsers" {
    "chromium-${chromiumRevision}" = chromium;
  };
in
{
  inherit driver browsers chromium;

  # CLI wrapper
  patchright-test = stdenv.mkDerivation {
    pname = "patchright-test";
    inherit version;

    dontUnpack = true;

    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
      mkdir -p $out/bin
      makeWrapper "${nodejs}/bin/node" "$out/bin/patchright" \
        --add-flags "${driver}/package/cli.js" \
        --set-default PLAYWRIGHT_BROWSERS_PATH "${browsers}"
    '';

    meta = {
      description = "Patchright CLI";
      mainProgram = "patchright";
    };
  };
}
