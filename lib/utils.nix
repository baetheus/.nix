{ nixpkgs, home-manager, nix-darwin, agenix, ... }:
let
  defaults = import ./defaults.nix;
in
{
  # Currently, I only run darwin systems for myself
  # so my darwinSystems are simple and only have
  # settings for me.
  mkDarwin =
    { hostname
    , module ? {}: { }
    , system ? defaults.darwin.system
    , username ? defaults.darwin.username
    , name ? defaults.darwin.name
    , email ? defaults.darwin.email
    ,
    }:
    let
      pkgs = import nixpkgs
        {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (self: super: { agenix = agenix.defaultPackage."${system}"; })
          ];
        };

      user = import ../home/user.nix {
        inherit pkgs username name email;
      };

      modules = [
        ../config/common.nix
        ../config/darwin.nix
        home-manager.darwinModule
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."${username}" = user;
        }
        module
      ];
    in
    nix-darwin.lib.darwinSystem { inherit system pkgs modules; };

  # My nixos configurations are pretty slim
  # I like to add only the things I really need via a single
  # module
  mkNixos =
    { hostname
    , module ? {}: { }
    , system ? defaults.nixos.system
    , username ? defaults.nixos.username
    , name ? defaults.nixos.name
    , email ? defaults.nixos.email
    ,
    }:
    let
      pkgs = import nixpkgs
        {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (self: super: { agenix = agenix.defaultPackage."${system}"; })
          ];
        };

      user = import ../home/user.nix {
        inherit pkgs username name email;
      };

      modules = [
        ../config/common.nix
        ../config/linux.nix
        agenix.nixosModule
        home-manager.nixosModule
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."${username}" = user;
        }
        module
      ];
    in
    nixpkgs.lib.nixosSystem { inherit system pkgs modules; };
}
