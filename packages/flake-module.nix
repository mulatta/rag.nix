_: {
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        inherit (pkgs.python3Packages) paper-qa;
        inherit (pkgs) pqa; # CLI wrapper
      };
    };
}
