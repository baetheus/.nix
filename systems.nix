inputs:
let
  inherit (import ./config/utils.nix inputs) mkDarwin mkNixos;
  inherit (inputs) age;
in
{
  darwinConfigurations = {
    # Personal Macbook Pro 13" 2018
    hopper = mkDarwin {
      hostname = "hopper";
      system = "x86_64-darwin";
    };

    # Personal Macbook Pro 14 2021
    rosalind = mkDarwin {
      hostname = "rosalind";
      system = "aarch64-darwin";
    };

    # Work Macbook Pro
    parks = mkDarwin {
      hostname = "parks";
      username = "brandonblaylock";
      name = "Brandon Blaylock";
      email = "bblaylock@cogility.com";
    };
  };

  nixosConfigurations = {
    # Primary Server
    bubbles = mkNixos {
      hostname = "bubbles";
      modules = [
        agenix.nixosModule
        ./config/age.nix
        ./config/bubbles/configuration.nix
      ];
    };

    # Media Server
    buttercup = mkNixos {
      hostname = "buttercup";
      modules = [
        agenix.nixosModule
        ./config/age.nix
        ./config/buttercup/configuration.nix
      ];
    };

    # Backup Server
    blossom = mkNixos {
      hostname = "blossom";
      modules = [
        agenix.nixosModule
        ./config/age.nix
        ./config/blossom/configuration.nix
      ];
    };
  };
}
