{
  description = "Brandon's Superflake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";

    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix/main";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    my-overlays.url = "./overlays";
  };

  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        shell = with pkgs; mkShell {
          buildInputs = [ nixos-anywhere ];
        };
      in
      {
        devShells.default = shell;
      }))
    // (import ./homes/default.nix inputs)
    // (import ./systems/default.nix inputs)
    // (import ./templates/default.nix inputs);
}


