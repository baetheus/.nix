# This file contains all of my system configurations
# assuming the inputs passed to the root level
# flake.nix
#
# It's primary outputs are
# - darwinConfigurations
# - nixosConfigurations
#
# TODO
# * Simplify darwin configurations to be more like
#   nixos configurations.
{ self, nixpkgs, home-manager, nix-darwin, agenix, ... }:
let
  # Create pkgs from nixpkgs using system and overlays
  # Prefer allowUnfree
  mkPkgs = { system, overlays ? [ ] }: import nixpkgs {
    inherit system overlays;
    config.allowUnfree = true;
  };

  # Supplement nixosSystem with flake inputs
  nixosSystem = nixpkgs.lib.nixosSystem;

  # Supplement darwinSystem with flake inputs
  darwinSystem = nix-darwin.lib.darwinSystem;

  # Shortcuts
  hm-nixos = home-manager.nixosModules.home-manager;
  hm-darwin = home-manager.darwinModules.home-manager;
in
{
  # Darwin configs are a little boilerplatey.. we could
  # do better to organize and setup modules/bundles.
  darwinConfigurations = {
    # Personal Macbook Pro 13" 2018
    hopper = darwinSystem rec {
      pkgs = mkPkgs { inherit system; };
      system = "x86_64-darwin";
      modules = [
        hm-darwin
        self.homes.brandon.default
        ./common/minimal.nix
        ./darwin/minimal.nix
      ];
    };

    # Personal Macbook Pro 14 2021
    rosalind = darwinSystem rec {
      pkgs = mkPkgs { inherit system; };
      system = "aarch64-darwin";
      modules = [
        hm-darwin
        self.homes.brandon.default
        ./common/minimal.nix
        ./darwin/minimal.nix
      ];
    };

    # Work Macbook Pro
    parks = darwinSystem rec {
      pkgs = mkPkgs { inherit system; };
      system = "aarch64-darwin";
      modules = [
        hm-darwin
        self.homes.brandonblaylock.default
        ./common/minimal.nix
        ./darwin/minimal.nix
      ];
    };
  };

  nixosConfigurations = {
    # Home Server
    toph = nixosSystem rec {
      pkgs = mkPkgs { inherit system; };
      system = "x86_64-linux";
      modules = [
        hm-nixos
        agenix.nixosModule
        self.homes.brandon.server
        ./toph.nix
      ];
    };

    # Private services (OVHCloud)
    abigail = nixosSystem rec {
      pkgs = mkPkgs { inherit system; };
      system = "x86_64-linux";
      modules = [
        hm-nixos
        agenix.nixosModule
        self.homes.brandon.server
        ./abigail.nix
      ];
    };

    # Public services (OVHCloud)
    bartleby = nixosSystem rec {
      pkgs = mkPkgs { inherit system; };
      system = "x86_64-linux";
      modules = [
        hm-nixos
        agenix.nixosModule
        self.homes.brandon.server
        ./bartleby.nix
      ];
    };
  };
}
