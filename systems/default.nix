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

{ self, nixpkgs, disko, home-manager, nix-darwin, agenix, ... }:
let
  defaultOverlays = [ ];

  # Create pkgs from nixpkgs using system and overlays
  # Prefer allowUnfree
  mkPkgs = { system, overlays ? defaultOverlays }: import nixpkgs {
    inherit system overlays;
    config.allowUnfree = true;
    # TODO: Remove asap
    config.permittedInsecurePackages = [
      "dotnet-sdk-6.0.428"
    ];
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
    diane = darwinSystem rec {
      pkgs = mkPkgs { inherit system; };
      system = "x86_64-darwin";
      modules = [
        hm-darwin
        self.homes.brandon.basic
        ./common/minimal.nix
        ./darwin/minimal.nix
        ./darwin/diane.nix
      ];
    };

    # Personal Macbook Pro 14 2021
    rosalind = darwinSystem rec {
      pkgs = mkPkgs { inherit system; };
      system = "aarch64-darwin";
      modules = [
        hm-darwin
        self.homes.brandon.basic
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
        agenix.nixosModules.age
        self.homes.brandon.basic
        ./toph.nix
      ];
    };

    # Private services (OVHCloud)
    abigail = nixosSystem rec {
      pkgs = mkPkgs { inherit system; };
      system = "x86_64-linux";
      modules = [
        hm-nixos
        agenix.nixosModules.age
        self.homes.brandon.basic
        ./abigail.nix
      ];
    };

    # Public services (OVHCloud)
    bartleby = nixosSystem rec {
      pkgs = mkPkgs { inherit system; };
      system = "x86_64-linux";
      modules = [
        hm-nixos
        agenix.nixosModules.age
        self.homes.brandon.basic
        ./bartleby.nix
      ];
    };

    # Test server (OVHCloud)
    clementine = nixosSystem rec {
      pkgs = mkPkgs { inherit system; };
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        hm-nixos
        self.homes.brandon.basic
        ./clementine.nix
      ];
    };
  };
}
