_: {
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        inherit (pkgs.python3Packages)
          paper-qa
          patchright
          crawl4ai
          langextract
          semanticscholar
          ;
        inherit (pkgs) pqa crwl; # CLI wrappers
      };
    };
}
