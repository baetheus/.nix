{ self, nixpkgs, home-manager, nix-darwin, agenix, ... }:
let
  defaults = import ./defaults.nix;
in
rec {
  # Create pkgs from nixpkgs using system and overlays
  mkPkgs = { system, overlays ? [ ] }: import nixpkgs {
    inherit system overlays;
    config.allowUnfree = true;
    config.packageOverrides = pkgs: {
      zfsStable = pkgs.zfsStable.override { enableMail = true; };
    };
  };

  # Creates home-manager module for a single user
  mkHomeUserModule = { pkgs, username, name, email }: {
    home-manager.users."${username}" = import ./home/simple.nix { inherit pkgs username name email; };
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
        ./configs/common.nix
        ./configs/darwin.nix
        ./configs/home-manager.nix
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
        ./configs/common.nix
        ./configs/linux.nix
        ./configs/home-manager.nix
      ] ++ modules;
    };
}
