{
  description = "A minimal devshell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.utils.url = "github:numtide/flake-utils";
  inputs.devshell.url = "github:numtide/devshell";

  outputs = { self, nixpkgs, utils, devshell  }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    overlays = [ devshell.overlay ];
    pkgs = import nixpkgs { inherit system overlays; };
    shell = with pkgs.devshell; mkShell {
      imports = [
        (importTOML ./devshell.toml)
      ];
      # Packages go here ?
      packages = [];
    };
  in {
    devShells = {
      default = shell;
    };
  });
}

