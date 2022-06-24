inputs:
let
  inherit (import ./utils.nix inputs) mkDarwin mkNixos;
  inherit (inputs) agenix;
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
        ./configs/age.nix
        ./configs/bubbles/configuration.nix
        ./configs/users/brandon.nix
      ];
    };

    # Media Server
    buttercup = mkNixos {
      hostname = "buttercup";
      modules = [
        agenix.nixosModule
        ./configs/age.nix
        ./configs/buttercup/configuration.nix
        ./configs/users/brandon.nix
      ];
    };

    # Backup Server
    blossom = mkNixos {
      hostname = "blossom";
      modules = [
        agenix.nixosModule
        ./configs/age.nix
        ./configs/blossom/configuration.nix
        ./configs/users/brandon.nix
      ];
    };
  };
}
