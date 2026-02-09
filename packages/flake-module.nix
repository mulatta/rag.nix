_: {
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        # keep-sorted start
        inherit (pkgs.python3Packages)
          docling-parse
          fhaviary
          fhlmi
          ldp
          openreview-py
          paper-qa
          paper-qa-docling
          paper-qa-nemotron
          paper-qa-pypdf
          pyzotero
          usearch
          ;
        # keep-sorted end
        inherit (pkgs) pqa; # CLI wrapper
      };
    };
}
