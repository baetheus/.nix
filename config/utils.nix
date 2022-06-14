{ self, nixpkgs, home-manager, nix-darwin, agenix, ... }:
let
  defaults = import ./defaults.nix;
in
rec {
  # Create pkgs from nixpkgs using system and overlays
  mkPkgs = { system, overlays ? [ ] }: import nixpkgs {
    inherit system overlays;
    config.allowUnfree = true;
  };

  
  # Creates a home-manager user for use with nixos or nix-darwin
  mkHomeUser =
    { pkgs, username, name, email, }:
    let
      user = import ../home/user.nix { inherit pkgs username name email; };
    in
    {

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${username}" = user;
    };

  # Create a darwinSystem with a single user and home-manager
  mkDarwin =
    { hostname
    , modules ? [ ] # darwin modules
    , overlays ? [ ] # nixpkgs overlays
    , system ? defaults.darwin.system
    , username ? defaults.darwin.username
    , name ? defaults.darwin.name
    , email ? defaults.darwin.email
    ,
    }:
    let
      pkgs = mkPkgs { inherit system overlays; };
      homeUser = mkHomeUser { inherit pkgs username name email; };
    in
    nix-darwin.lib.darwinSystem {
      inherit system pkgs;
      modules = [
        home-manager.darwinModule
        homeUser
      ] ++ modules;
    };

  # Create a nixosSystem with a single user, home-manager, and agenix
  # Note: expects id_ed25519_shared in /keys for secrets
  mkNixos =
    { hostname
    , modules ? [ ] # nixos modules
    , overlays ? [ ] # nixpkgs overlays
    , system ? defaults.nixos.system
    , username ? defaults.nixos.username
    , name ? defaults.nixos.name
    , email ? defaults.nixos.email
    ,
    }:
    let
      pkgs = mkPkgs { inherit system overlays; };
      homeUser = mkHomeUser { inherit pkgs username name email; };
    in
    nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      modules = [
        agenix.nixosModule
        {
          age.identityPaths = [ "/keys/id_ed25519_shared" ];
        }
        home-manager.nixosModule
        homeUser
      ] ++ modules;
    };
}
