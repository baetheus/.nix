{
  description = "Brandon's Superflake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:nixos/nixpkgs/release-23.05";

    nix-darwin.url = "github:lnl7/nix-darwin/release-23.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix/main";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    (import ./homes/default.nix inputs)
    // (import ./systems/default.nix inputs)
    // (import ./templates/default.nix inputs);

}


