{
  description = "Devshell for managing secrets";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.agenix-flake.url = "github:ryantm/agenix";
  inputs.agenix-flake.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, flake-utils, agenix-flake }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ agenix-flake.overlay ];
      };
      shell = with pkgs; mkShell {
        packages = [ agenix age-plugin-yubikey yubikey-manager ];
      };
    in {
      devShells.default = shell;
    });
}

