pkgs:
with pkgs; [
  alejandra
  elmPackages.elm-format
  gotools
  haskellPackages.cabal-fmt
  haskellPackages.ormolu
  mdsh
  nixpkgs-fmt
  nodePackages.prettier
  python3.pkgs.black
  rufo
  rustfmt
  shellcheck
  shfmt
  statix
  deadnix
  terraform
]
