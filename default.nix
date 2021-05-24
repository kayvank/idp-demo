{ compiler ? "ghc8104" }:

let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {
    config = {
      allowBroken = true;
      allowUnfree = true;
    };
  };

  gitignore = pkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];

  myHaskellPackages = pkgs.haskell.packages.${compiler}.override {
    overrides = hself: hsuper: {
      "idp-demo" =
        hself.callCabal2nix
          "idp-demo"
          (gitignore ./.)
          {};
    };
  };

  shell = myHaskellPackages.shellFor {
    packages = p: [
      p."idp-demo"
    ];

    buildInputs = [
      pkgs.haskellPackages.cabal-install
      pkgs.haskellPackages.ghcid
      pkgs.haskellPackages.ormolu
      pkgs.haskellPackages.hpack
      pkgs.haskellPackages.hlint
      pkgs.niv
      pkgs.nixpkgs-fmt
    ];
  shellHook = ''
    hpack
    '' ;
  };
  exe = pkgs.haskell.lib.justStaticExecutables (myHaskellPackages."idp-demo");

  docker = pkgs.dockerTools.buildImage {
    name = "idp-demo";
    config.Cmd = [ "${exe}/bin/idp-demo" ];
  };
in
{
  inherit shell;
  inherit exe;
  inherit docker;
  inherit myHaskellPackages;
  "idp-demo" = myHaskellPackages."idp-demo";
}
