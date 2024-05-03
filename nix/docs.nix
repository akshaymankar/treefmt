_: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.docs = pkgs.buildNpmPackage {
      pname = "treefmt-docs";
      inherit (self'.packages.default) version;

      src = ../docs;
      npmDepsHash = "sha256-J9qTWueOcSBq7qRec6YdTuWI2VlVQ0q6AynDLovf6s0=";

      # we have to use a custom build phase because vitepress is doing something funky with the ttty
      buildPhase = ''
        cat | npm run build 2>&1 | cat
      '';

      installPhase = ''
        runHook preInstall
        cp -rv .vitepress/dist/ $out
        runHook postInstall
      '';
    };

    devshells.default = {
      packages = [
        pkgs.nodejs
      ];

      commands = let
        category = "docs";
      in [
        {
          inherit category;
          name = "docs:dev";
          help = "serve docs for local development";
          command = "cd $PRJ_ROOT/docs && npm run dev";
        }
        {
          inherit category;
          name = "docs:build";
          help = "create a production build of docs";
          command = "cd $PRJ_ROOT/docs && npm run build";
        }
        {
          inherit category;
          name = "docs:preview";
          help = "preview a production build of docs";
          command = "cd $PRJ_ROOT/docs && npm run preview";
        }
        {
          inherit category;
          name = "vhs";
          help = "generate terminal gifs";

          package = pkgs.writeShellApplication {
            name = "gif";
            runtimeInputs =
              [
                self'.packages.treefmt
                pkgs.rsync
                pkgs.vhs
              ]
              ++ (import ./formatters.nix pkgs);
            text = ''vhs "$@"'';
          };
        }
      ];
    };
  };
}