{
  # TODO: Add a description
  description = "Description of project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = {
    devenv,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
      imports = [devenv.flakeModule];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # needed for devenv up
        packages.devenv-up = self'.devShells.default.config.procfileScript;

        devenv.shells.default = {
          name = "micromamba";

          env.MAMBA_ROOT_PREFIX = "${config.env.DEVENV_STATE}/micromamba";
          env.GREET = "󱄅 Nix";
          scripts.hello.exec = "echo $GREET";

          packages = with pkgs; [
            micromamba
            stdenv.cc.cc.lib # required by Jupyter
            zlib
            glibc
            python311Packages.pip
            ruff
            nodePackages.pyright
            just
          ];

          pre-commit.hooks = {
            ruff.enable = true;
            shellcheck.enable = true;
            markdownlint.enable = true;
            alejandra.enable = true;
            editorconfig-checker.enable = true;
          };

          dotenv.enable = true;

          env.LD_LIBRARY_PATH = with pkgs;
            lib.makeLibraryPath [
              stdenv.cc.cc.lib
              zlib
            ];

          enterShell = ''
            set -h
            eval "$(micromamba shell hook --shell=bash)"
          '';
        };
      };
    };
}
