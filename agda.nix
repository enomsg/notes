{ nixpkgs ? import <nixpkgs> {} }:

with nixpkgs;

let
  ghc   = pkgs.haskellPackages.ghcWithPackages
            (p: with p; [ ieee754 ]);
  emacs = pkgs.emacsWithPackages
            (p: with p; [ use-package evil agda2-mode company
                          rainbow-delimiters ]);
  der   = agda.mkDerivation(self: {
    name         = "AgdaEnv";
    buildDepends = [ pkgs.AgdaStdlib ghc emacs ];
  });
in der.env
