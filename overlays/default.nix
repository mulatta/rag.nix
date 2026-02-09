_final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (py-final: _py-prev: {
      docling-parse = py-final.callPackage ../packages/docling-parse/package.nix { };
      fhaviary = py-final.callPackage ../packages/fhaviary/package.nix { };
      fhlmi = py-final.callPackage ../packages/fhlmi/package.nix { };
      ldp = py-final.callPackage ../packages/ldp/package.nix { };
      openreview-py = py-final.callPackage ../packages/openreview-py/package.nix { };
      paper-qa = py-final.callPackage ../packages/paper-qa/package.nix { };
      paper-qa-pymupdf = py-final.callPackage ../packages/paper-qa-pymupdf/package.nix { };
      paper-qa-pypdf = py-final.callPackage ../packages/paper-qa-pypdf/package.nix { };
      pyzotero = py-final.callPackage ../packages/pyzotero/package.nix { };
      usearch = py-final.callPackage ../packages/usearch/package.nix { };
    })
  ];

  # CLI wrapper using toPythonApplication
  pqa = prev.python3Packages.toPythonApplication prev.python3Packages.paper-qa;
}
