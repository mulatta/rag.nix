final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (py-final: py-prev: {
      # Override docling to relax version constraints for docling-parse and typer
      docling = py-prev.docling.overridePythonAttrs (old: {
        pythonRelaxDeps = (old.pythonRelaxDeps or [ ]) ++ [
          "typer"
          "docling-parse"
        ];
      });

      # Existing packages
      docling-parse = py-final.callPackage ../packages/docling-parse/package.nix { };
      fhaviary = py-final.callPackage ../packages/fhaviary/package.nix { };
      fhlmi = py-final.callPackage ../packages/fhlmi/package.nix { };
      ldp = py-final.callPackage ../packages/ldp/package.nix { };
      openreview-py = py-final.callPackage ../packages/openreview-py/package.nix { };
      paper-qa = py-final.callPackage ../packages/paper-qa/package.nix { };
      paper-qa-docling = py-final.callPackage ../packages/paper-qa-docling/package.nix { };
      paper-qa-nemotron = py-final.callPackage ../packages/paper-qa-nemotron/package.nix { };
      paper-qa-pymupdf = py-final.callPackage ../packages/paper-qa-pymupdf/package.nix { };
      paper-qa-pypdf = py-final.callPackage ../packages/paper-qa-pypdf/package.nix { };
      pyzotero = py-final.callPackage ../packages/pyzotero/package.nix { };
      langextract = py-final.callPackage ../packages/langextract/package.nix { };
      semanticscholar = py-final.callPackage ../packages/semanticscholar/package.nix { };
      usearch = py-final.callPackage ../packages/usearch/package.nix { };

      # crawl4ai dependencies
      fake-http-header = py-final.callPackage ../packages/fake-http-header/package.nix { };
      alphashape = py-final.callPackage ../packages/alphashape/package.nix { };
      tf-playwright-stealth = py-final.callPackage ../packages/tf-playwright-stealth/package.nix { };

      # Patchright (anti-detection playwright)
      patchright = py-final.callPackage ../packages/patchright/package.nix { };

      # crawl4ai
      crawl4ai = py-final.callPackage ../packages/crawl4ai/package.nix { };

      # mem0ai and dependencies
      # TODO: Remove redis5 when nixpkgs redis updates to satisfy >=5.0.0,<6.0.0
      redis5 = py-final.callPackage ../packages/redis5/package.nix { };
      mem0ai = py-final.callPackage ../packages/mem0ai/package.nix {
        redis = py-final.redis5;
      };

      # cognee dependencies
      cbor2 = py-final.callPackage ../packages/cbor2/package.nix { };
    })
  ];

  # CLI wrappers
  pqa = prev.python3Packages.toPythonApplication final.python3Packages.paper-qa;
  crwl = prev.python3Packages.toPythonApplication final.python3Packages.crawl4ai;
}
