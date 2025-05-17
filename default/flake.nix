{
  # TODO: Add a description
  description = "Description of project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
  };
  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = {
    self,
    nixpkgs,
    devenv,
    systems,
    ...
  } @ inputs: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
  in {
    packages = forEachSystem (system: {
      devenv-up = self.devShells.${system}.default.config.procfileScript;
    });

    devShells = forEachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          {
            packages = with pkgs; [
              just
              ruff
              terraform
              zlib
            ];

            env = {GREET = "Determinate";};

            scripts.hello.exec = "echo $GREET";

            languages.clojure.enable = true;

            languages.javascript = {
              enable = true;
              yarn.enable = true;
            };

            languages.java = {
              enable = true;
              gradle.enable = true;
              jdk.package = pkgs.jdk11;
            };
            
            languages.kotlin.enable = true;

            languages.python = {
              package = pkgs.python312;
              enable = true;
              uv = {
                enable = true;
                sync.enable = true;
                sync.allExtras = true;
              };
              venv = {enable = true;};
            };

            languages.typescript.enable = true;

            pre-commit.hooks = {
              ruff.enable = false;
              shellcheck.enable = true;
              markdownlint.enable = true;
              alejandra.enable = true;
              editorconfig-checker.enable = true;
            };

            dotenv.enable = true;

            env.LD_LIBRARY_PATH = with pkgs;
              lib.makeLibraryPath [
                zlib
              ];
          }
        ];
      };
    });
  };
}

