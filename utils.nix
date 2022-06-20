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

  # Creates a simple home user configuration
  mkHomeUser = { pkgs, username, name, email }: import ../home-manager/simple.nix { inherit pkgs username name email; };

  # Creates home-manager module for a single user
  mkHomeUserModule = { pkgs, username, name, email }: {
    home-manager.users."username" = mkHomeUser { inherit pkgs username name email; };
  };

  # Create a basic darwin system
  mkDarwin =
    { hostname
    , system ? defaults.darwin.system
    , username ? defaults.darwin.username
    , name ? defaults.darwin.name
    , email ? defaults.darwin.email
    , modules ? [ ] # darwin modules
    , overlays ? [ ] # nixpkgs overlays
    }:
    let
      pkgs = mkPkgs { inherit system overlays; };
      user = mkHomeUserModule { inherit pkgs username name email; };
    in
    nix-darwin.lib.darwinSystem {
      inherit system pkgs;
      modules = [
        home-manager.darwinModules.home-manager
        user
        ./config/common.nix
        ./config/darwin.nix
        ./config/home-manager.nix
      ] ++ modules;
    };

  # Create a nixosSystem with a single user, home-manager, and agenix
  mkNixos =
    { hostname
    , system ? defaults.nixos.system
    , username ? defaults.nixos.username
    , name ? defaults.nixos.name
    , email ? defaults.nixos.email
    , modules ? [ ] # nixos modules
    , overlays ? [ ] # nixpkgs overlays
    }:
    let
      pkgs = mkPkgs { inherit system overlays; };
      user = mkHomeUserModule { inherit pkgs username name email; };
    in
    nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      modules = [
        home-manager.darwinModules.home-manager
        user
        ./config/common.nix
        ./config/linux.nix
        ./config/home-manager.nix
      ] ++ modules;
    };
}
