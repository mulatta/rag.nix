_final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (py-final: _py-prev: {
      fhaviary = py-final.callPackage ../packages/fhaviary/package.nix { };
      fhlmi = py-final.callPackage ../packages/fhlmi/package.nix { };
      paper-qa = py-final.callPackage ../packages/paper-qa/package.nix { };
      paper-qa-pymupdf = py-final.callPackage ../packages/paper-qa-pymupdf/package.nix { };
      paper-qa-pypdf = py-final.callPackage ../packages/paper-qa-pypdf/package.nix { };
    })
  ];

  # CLI wrapper using toPythonApplication
  pqa = prev.python3Packages.toPythonApplication prev.python3Packages.paper-qa;
}
