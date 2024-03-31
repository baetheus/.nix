{
  description = "A simple flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/23.11";
  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      shell = with pkgs; mkShell {
        # Insert Packages Here
        packages = [];
      };
    in {
      devShells.default = shell;
    });
}

