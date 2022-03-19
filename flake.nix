{
  description = "Brandon's System Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { darwin, nixpkgs, home-manager, ... }:
  let
    inherit (nixpkgs.lib) genAttrs;

    system = "x86_64-darwin";
    hostnames = ["euclid" "hopper"];

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    darwinConfigurations = genAttrs hostnames (hostname:
      darwin.lib.darwinSystem {
        inherit system pkgs;
        inputs = { inherit darwin; };
        modules = [
          ./configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.brandon = import ./users/brandon.nix;
          }
        ];
      }
    );
  };
}
