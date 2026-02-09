_final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (_py-final: _py-prev: {
      # paper-qa = py-final.callPackage ../packages/paper-qa/package.nix { };
    })
  ];
}
