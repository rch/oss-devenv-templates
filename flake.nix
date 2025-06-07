{
  description = "A collection of development environment configurations based on Nix flakes";

  outputs = {
    self,
    nixpkgs,
  }: {
    templates = {
      default = {
        path = ./default;
        description = "Default development environment";
      };
      python = {
        path = ./python;
        description = "Python development environment";
      };
      quarto = {
        path = ./quarto;
        description = "Quarto notes environment";
      };
      julia = {
        path = ./julia;
        description = "Julia development environment";
      };
    };
  };
}
