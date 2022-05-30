inputs:
let
  inherit (import ./lib/utils.nix inputs) mkDarwin mkNixos;
in
{
  darwinConfigurations = {
    euclid = mkDarwin {
      hostname = "euclid";
      modules = [
        ./config/common.nix
        ./config/darwin.nix
      ];
    };
    hopper = mkDarwin {
      hostname = "hopper";
      modules = [
        ./config/common.nix
        ./config/darwin.nix
      ];
    };
    parks = mkDarwin {
      hostname = "parks";
      system = "aarch64-darwin";
      username = "brandonblaylock";
      name = "Brandon Blaylock";
      email = "bblaylock@cogility.com";
      modules = [
        ./config/common.nix
        ./config/darwin.nix
      ];
    };
  };

  nixosConfigurations = {
    bubbles = mkNixos {
      hostname = "bubbles";
      modules = [
        ./config/common.nix
        ./config/linux.nix
        ./config/bubbles/configuration.nix
      ];
    };
  };
}
