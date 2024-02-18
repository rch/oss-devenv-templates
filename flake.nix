{
  description =
    "A collection of development environment configurations based on Nix flakes";

  outputs = { self, nixpkgs }: {
    templates = {
      python = {
        path = ./python;
        description = "Python development environment";
      };
    };
  };
}
