# This file contains utils that should simplify the
# creation of home-manager users, nixos configs,
# and nix-darwin configs.
#
# I think moving to system definitions using 
# bundles in nixos is ideal and this file should be
# split between systems/default.nix and
# homes/default.nix
{ self, nixpkgs, home-manager, nix-darwin, agenix, ... }:
let
  defaults = import ./defaults.nix;
in
rec {
  # ---
  # General Utilities
  # ---

  # Create pkgs from nixpkgs using system and overlays
  mkPkgs = { system, overlays ? [ ] }: import nixpkgs {
    inherit system overlays;
    config.allowUnfree = true;
  };

  # ---
  # Home Manager Utilities
  # ---

  # Flatten ref to home-manager nixosModules
  nixosHome = home-manager.nixosModules.home-manager;

  # Flatten ref to home-manager darwinModules
  darwinHome = home-manager.darwinModules.home-manager;

  # Creates home-manager module for a single server user
  mkServerUser =
    { username ? defaults.home.username
    , name ? defaults.home.name
    , email ? defaults.home.email
    }: {
      home-manager.useGlobalPkgs = true;
      home-manager.users."${username}" = import ./homes/server.nix;
      # Passes username, name, and email to nested hm modules
      home-manager.extraSpecialArgs = {
        more = { inherit username name email; };
      };
    };

  # Creates home-manager module for a single desktop user
  mkDesktopUser =
    { username ? defaults.home.username
    , name ? defaults.home.name
    , email ? defaults.home.email
    }: {
      home-manager.useGlobalPkgs = true;
      home-manager.users."${username}" = import ./homes/desktop.nix;
      # Passes username, name, and email to nested hm modules
      home-manager.extraSpecialArgs = {
        more = { inherit username name email; };
      };
    };

  # Default homes
  homes = {
    server = (mkServerUser { });
    desktop = (mkDesktopUser { });
  };

  # ---
  # System Utilities
  # ---

  # Create a basic darwin system
  mkDarwin =
    { hostname
    , system ? defaults.darwin.system
    , modules ? [ ] # darwin modules
    , overlays ? [ ] # nixpkgs overlays
    }:
    let
      pkgs = mkPkgs { inherit system overlays; };
    in
    nix-darwin.lib.darwinSystem {
      inherit system pkgs modules;
    };

  # Create a basic nixosSystem
  mkNixos =
    { hostname
    , system ? defaults.nixos.system
    , modules ? [ ] # nixos modules
    , overlays ? [ ] # nixpkgs overlays
    }:
    let
      pkgs = mkPkgs { inherit system overlays; };
    in
    nixpkgs.lib.nixosSystem {
      inherit system pkgs modules;
    };

}
