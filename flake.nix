{
  description = "Brandon's System Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix/main";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    let
      inherit (import ./lib/utils.nix inputs) mkDarwin mkNixos;
    in
    {
      darwinConfigurations = {
        euclid = mkDarwin { hostname = "euclid"; };
        hopper = mkDarwin { hostname = "hopper"; };
        parks = mkDarwin {
          hostname = "parks";
          system = "aarch64-darwin";
          username = "brandonblaylock";
          name = "Brandon Blaylock";
          email = "bblaylock@cogility.com";
        };
      };

      nixosConfigurations = {
        bubbles = mkNixos {
          hostname = "bubbles";
          module = ./config/bubbles/configuration.nix;
        };
      };
    };
}


