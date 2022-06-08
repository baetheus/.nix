inputs:
let
  inherit (import ./lib/utils.nix inputs) mkDarwin mkNixos;
  darwinModules = [
    ./config/common.nix
    ./config/darwin.nix
  ];
in
{
  darwinConfigurations = {
    # Personal Macbook Pro 13" 2018
    euclid = mkDarwin {
      hostname = "euclid";
      modules = darwinModules;
    };

    # Work Macbook Pro
    parks = mkDarwin {
      hostname = "parks";
      system = "aarch64-darwin";
      username = "brandonblaylock";
      name = "Brandon Blaylock";
      email = "bblaylock@cogility.com";
      modules = darwinModules;
    };
  };

  nixosConfigurations = {
    # Primary Server
    bubbles = mkNixos {
      hostname = "bubbles";
      modules = [
        ./config/common.nix
        ./config/linux.nix
        ./config/users.nix
        ./config/bubbles/configuration.nix
      ];
    };

    # Media Server
    buttercup = mkNixos {
      hostname = "buttercup";
      modules = [
        ./config/common.nix
        ./config/linux.nix
        ./config/users.nix
        ./config/buttercup/configuration.nix
      ];
    };

    # Backup Server
    blossom = mkNixos {
      hostname = "blossom";
      modules = [
        ./config/common.nix
        ./config/linux.nix
        ./config/users.nix
        ./config/blossom/configuration.nix
      ];
    };
  };
}
