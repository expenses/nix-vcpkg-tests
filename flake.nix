{
  description = "Flake utils demo";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        packages.default = with pkgs; stdenv.mkDerivation {
          name = "vcpkg-tests";
          src = ./.;
          env.VCPKG_OVERLAY_TRIPLETS = "${vcpkg}/share/vcpkg/triplets";
          nativeBuildInputs = [vcpkg cacert git];
          buildPhase = ''
            mkdir -p $out/scripts
            ln -s ${vcpkg}/share/vcpkg/scripts/vcpkgTools.xml $out/scripts/vcpkgTools.xml
            HOME=$(pwd) VCPKG_ROOT=$out vcpkg install --only-downloads
          '';
          outputHashAlgo = "sha256";
        outputHashMode = "recursive";
        outputHash = "";
        };
      }
    );
}
