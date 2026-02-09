# TODO: Switch to native build (nixpkgs python3Packages.docling-parse) when
# nlohmann_json compatibility issue is resolved upstream.
# See: https://github.com/docling-project/docling-parse/issues/172
# Currently using pre-built wheel to avoid C++ compilation errors.
{
  lib,
  stdenv,
  buildPythonPackage,
  fetchurl,
  python,
  autoPatchelfHook,
  tabulate,
  pillow,
  pydantic,
  docling-core,
  # native libs for Linux wheels
  zlib,
  libjpeg,
  qpdf,
}:

let
  version = "4.7.3";
  pythonVersionNoDot = builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;

  # Wheel sources indexed by "pythonVersion-system"
  # Using 4.x to satisfy docling's constraint (docling-parse<5.0.0)
  srcs = {
    # Python 3.12
    "312-x86_64-linux" = {
      url = "https://files.pythonhosted.org/packages/3e/47/a722527c9f89c65f69f8a463be4f12ad73bae18132f29d8de8b2d9f6f082/docling_parse-4.7.3-cp312-cp312-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
      hash = "sha256-3DK28lpnPkG5qBEraBQohPYNusmDH3hIoDQ0Rg9XTq4=";
    };
    "312-aarch64-linux" = {
      url = "https://files.pythonhosted.org/packages/f2/fd/1aebb8a7f15d658f3be858ddbbc4ef7206089d540a7df0dcd4b846b99901/docling_parse-4.7.3-cp312-cp312-manylinux_2_26_aarch64.manylinux_2_28_aarch64.whl";
      hash = "sha256-3/0Z7Tc7DaXOoSRgBrGDSJqGhsPRhkPpSEW+HbXXE+o=";
    };
    "312-aarch64-darwin" = {
      url = "https://files.pythonhosted.org/packages/d6/26/9d86ae12699a25b7233f76ce062253e9c14e57781e00166b792b3a9d56db/docling_parse-4.7.3-cp312-cp312-macosx_14_0_arm64.whl";
      hash = "sha256-2JIxqk+6PjjguAxb6HvAdWnpNML5NbtRv1eQT+/plLU=";
    };
    # Python 3.13
    "313-x86_64-linux" = {
      url = "https://files.pythonhosted.org/packages/cf/e6/899f033d80cb2b4e182226c73c6e91660df42e8867b76a04f0c024db7cb6/docling_parse-4.7.3-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
      hash = "sha256-9Kk/kflwVeGcreM7uVfYP4YV8dKgEDuJgnrKFrMaPiI=";
    };
    "313-aarch64-linux" = {
      url = "https://files.pythonhosted.org/packages/15/c4/a18d70118ff26b12021effab53d2ffe0c7e6ef378e92c35941b5557529c1/docling_parse-4.7.3-cp313-cp313-manylinux_2_26_aarch64.manylinux_2_28_aarch64.whl";
      hash = "sha256-nRilsfeeyr7jMcSXoZ8Z0oGg2G8kvL5dOeP9ib3E3zI=";
    };
    "313-aarch64-darwin" = {
      url = "https://files.pythonhosted.org/packages/c9/9f/b62390c85f99436fd0c40cfcdfea2b553482696ca735e4cc0eee96b765aa/docling_parse-4.7.3-cp313-cp313-macosx_14_0_arm64.whl";
      hash = "sha256-bLT+jGLeBucObjjEvWCI9B6PnHRVKTgX5o8TYlP46JQ=";
    };
  };

  srcKey = "${pythonVersionNoDot}-${stdenv.hostPlatform.system}";
  src =
    srcs.${srcKey}
      or (throw "docling-parse: unsupported Python ${python.pythonVersion} on ${stdenv.hostPlatform.system}");
in
buildPythonPackage {
  pname = "docling-parse";
  inherit version;
  format = "wheel";

  src = fetchurl src;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib # libstdc++
    zlib
    libjpeg
    qpdf
  ];

  dependencies = [
    tabulate
    pillow
    pydantic
    docling-core
  ];

  pythonImportsCheck = [ "docling_parse" ];

  meta = {
    description = "Simple package to extract text with coordinates from programmatic PDFs";
    homepage = "https://github.com/docling-project/docling-parse";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
