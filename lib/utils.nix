{ self, nixpkgs, home-manager, nix-darwin, agenix, impermanence, ... }:
let
  defaults = import ./defaults.nix;
in
{
  mkPkgs = { system, overlays ? [ ] }: import nixpkgs {
    inherit system;
    overlays = [
      (self: super: { agenix = agenix.defaultPackage."${system}"; })
    ] ++ overlays;
    config.allowUnfree = true;
  };

  mkDarwin =
    { hostname
    , modules ? [ ]
    , overlays ? [ ]
    , system ? defaults.darwin.system
    , username ? defaults.darwin.username
    , name ? defaults.darwin.name
    , email ? defaults.darwin.email
    ,
    }:
    let
      pkgs = self.mkPkgs { inherit system overlays; };
      user = import ../home/user.nix {
        inherit pkgs username name email;
      };
    in
    nix-darwin.lib.darwinSystem {
      inherit system pkgs;
      modules = [
        home-manager.darwinModule
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."${username}" = user;
        }
      ] ++ modules;
    };

  mkNixos =
    { hostname
    , modules ? [ ]
    , overlays ? [ ]
    , system ? defaults.nixos.system
    , username ? defaults.nixos.username
    , name ? defaults.nixos.name
    , email ? defaults.nixos.email
    ,
    }:
    let
      pkgs = self.mkPkgs { inherit system overlays; };
      user = import ../home/user.nix {
        inherit pkgs username name email;
      };
    in
    nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      modules = [

        agenix.nixosModule
        {
          age.identityPaths = [ "/keys/id_ed25519_shared" ];
        }
        home-manager.nixosModule
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."${username}" = user;
        }
      ] ++ modules;
    };
}
