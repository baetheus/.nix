{
  description = "A simple rust flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05";
  inputs.utils.url = "github:numtide/flake-utils";
  inputs.rust-overlay = {
    url = "github:oxalica/rust-overlay";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      flake-utils.follows = "utils";
    };
  };

  outputs = { self, nixpkgs, utils, rust-overlay }:
    utils.lib.eachDefaultSystem (system: let
      overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs { inherit system overlays; };
      rustToolchain = pkgs.pkgsBuildHost.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
      shell = with pkgs; mkShell {
        buildInputs = [ rustToolchain ];
        # Insert Packages Here
        packages = [];
      };
    in {
      devShells.default = shell;
    });
}

