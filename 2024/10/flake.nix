{
  description = "advent of code 2024 day 10 in odin";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          odin
        ];
        shellHook = ''
          echo "Entering odin devshell..."
        '';
      };
    };
}
