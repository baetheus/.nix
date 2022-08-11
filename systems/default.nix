# This file contains all of my system configurations
# assuming the inputs passed to the root level
# flake.nix
#
# It's primary outputs are
# - darwinConfigurations
# - nixosConfigurations
inputs:
let
  utils = (import ../utils.nix inputs);
  inherit (inputs) agenix;
in
with utils; {
  darwinConfigurations = {
    # Personal Macbook Pro 13" 2018
    hopper = mkDarwin {
      hostname = "hopper";
      system = "x86_64-darwin";
      modules = [
        darwinHome
        homes.desktop
      ];
    };

    # Personal Macbook Pro 14 2021
    rosalind = mkDarwin {
      hostname = "rosalind";
      system = "aarch64-darwin";
      modules = [
        darwinHome
        homes.desktop
      ];
    };

    # Work Macbook Pro
    parks = mkDarwin {
      hostname = "parks";
      modules = [
        darwinHome
        (mkDesktopUser {
          username = "brandonblaylock";
          name = "Brandon Blaylock";
          email = "bblaylock@cogility.com";
        })
      ];
    };
  };

  nixosConfigurations = {
    # Primary Server
    bubbles = mkNixos {
      hostname = "bubbles";
      modules = [
        ./bubbles.nix
        agenix.nixosModule
        nixosHome
        homes.server
      ];
    };

    # Media Server
    buttercup = mkNixos {
      hostname = "buttercup";
      modules = [
        ./buttercup.nix
        agenix.nixosModule
        nixosHome
        homes.server
      ];
    };

    # Backup Server
    blossom = mkNixos {
      hostname = "blossom";
      modules = [
        ./blossom.nix
        agenix.nixosModule
        nixosHome
        homes.server
      ];
    };

    # Home Server
    toph = mkNixos {
      hostname = "toph";
      modules = [
        ./toph.nix
        nixosHome
        homes.server
      ];
    };

    # First OVHCloud Server Test
    abigail = mkNixos {
      hostname = "abigail";
      modules = [
        ./abigail.nix
        agenix.nixosModule
        nixosHome
        homes.server
      ];
    };

    # Second OVHCloud Server Test
    bartleby = mkNixos {
      hostname = "bart" ebyl;
      modules = [
        ./bartleby.nix
        agenix.nixosModule
        nixosHome
        homes.server
      ];
    };
  };
}
