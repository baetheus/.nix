# This file contains all of my system configurations
# assuming the inputs passed to the root level
# flake.nix
#
# It's primary outputs are
# - darwinConfigurations
# - nixosConfigurations
#
# TODO:
# 1. Get agenix.nixosModule into an overlay
#    so it can be used via modules/agenix.nix
{ self, nixpkgs, home-manager, nix-darwin, agenix, ... }:
let
  # Seeded home modules
  homes = self.homes;

  # Create pkgs from nixpkgs using system and overlays
  mkPkgs = { system, overlays ? [ ] }: import nixpkgs {
    inherit system overlays;
    config.allowUnfree = true;
  };

  # Create a basic darwin system
  mkDarwin =
    { hostname
    , system ? "aarch64-darwin"
    , homes ? [ ] # home modules
    , modules ? [ ] # darwin modules
    , overlays ? [ ] # nixpkgs overlays
    }:
    let
      pkgs = mkPkgs { inherit system overlays; };
      mods = if homes == [ ] then modules else modules ++ [ home-manager.darwinModules.home-manager ] ++ homes;
    in
    nix-darwin.lib.darwinSystem {
      inherit system pkgs;
      modules = mods;
    };

  mkNixos =
    { hostname
    , system ? "x86_64-linux"
    , homes ? [ ] # home modules
    , modules ? [ ] # nixos modules
    , overlays ? [ ] # nixpkgs overlays
    }:
    let
      pkgs = mkPkgs { inherit system overlays; };
      mods = if homes == [ ] then modules else modules ++ [ home-manager.nixosModules.home-manager ] ++ homes;
    in
    nix-darwin.lib.darwinSystem {
      inherit system pkgs;
      modules = mods;
    };
in
{
  darwinConfigurations = {
    # Personal Macbook Pro 13" 2018
    hopper = mkDarwin {
      hostname = "hopper";
      system = "x86_64-darwin";
      homes = [ homes.brandon.default ];
      modules = [
        ./darwin/minimal.nix
        ./darwin/nix.nix
        ./users/brandon-darwin.nix
      ];
    };

    # Personal Macbook Pro 14 2021
    rosalind = mkDarwin {
      hostname = "rosalind";
      homes = [ homes.brandon.default ];
      modules = [
        ./darwin/minimal.nix
        ./darwin/nix.nix
        ./users/brandon-darwin.nix
      ];
    };

    # Work Macbook Pro
    parks = mkDarwin {
      hostname = "parks";
      homes = [ homes.brandon.work ];
      modules = [
        ./darwin/minimal.nix
        ./darwin/nix.nix
        ./users/brandon-darwin.nix
      ];
    };
  };

  nixosConfigurations = {
    # Home Server
    toph = mkNixos {
      hostname = "toph";
      homes = [ homes.brandon.server ];
      modules = [
        ./toph.nix
        agenix.nixosModule
      ];
    };

    # Private services (OVHCloud)
    abigail = mkNixos {
      hostname = "abigail";
      homes = [ homes.brandon.server ];
      modules = [
        ./abigail.nix
        agenix.nixosModule
      ];
    };

    # Public services (OVHCloud)
    bartleby = mkNixos {
      hostname = "bartleby";
      homes = [ homes.brandon.server ];
      modules = [
        ./bartleby.nix
        agenix.nixosModule
      ];
    };

    # Cluster Test 1 (SYS)
    bubbles = mkNixos {
      hostname = "bubbles";
      homes = [ homes.brandon.server ];
      modules = [
        ./bubbles.nix
        agenix.nixosModule
      ];
    };

    # Cluster Test 2 (SYS)
    buttercup = mkNixos {
      hostname = "buttercup";
      homes = [ homes.brandon.server ];
      modules = [
        ./buttercup.nix
        agenix.nixosModule
      ];
    };

    # Cluster Test 3 (SYS)
    blossom = mkNixos {
      hostname = "blossom";
      homes = [ homes.brandon.server ];
      modules = [
        ./blossom.nix
        agenix.nixosModule
      ];
    };
  };
}
