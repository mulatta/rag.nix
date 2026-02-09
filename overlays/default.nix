_final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (py-final: _py-prev: {
      fhaviary = py-final.callPackage ../packages/fhaviary/package.nix { };
    })
  ];
}
