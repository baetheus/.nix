{
  description = "Brandon's System Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/21.11";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    helix.url = "github:helix-editor/helix/master";
    helix.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { darwin, nixpkgs, home-manager, helix, deploy-rs, ... }:
    let
      darwinSystems = [
        {
          hostname = "euclid";
          system = "x86_64-darwin";
          username = "brandon";
          name = "Brandon Blaylock";
          email = "brandon@null.pub";
        }
        {
          hostname = "hopper";
          system = "x86_64-darwin";
          username = "brandon";
          name = "Brandon Blaylock";
          email = "brandon@null.pub";
        }
        {
          hostname = "parks";
          system = "aarch64-darwin";
          username = "brandonblaylock";
          name = "Brandon Blaylock";
          email = "bblaylock@cogility.com";
        }
      ];
    in
    {
      darwinConfigurations = builtins.foldl'
        (configs: { hostname
                  , system
                  , username
                  , name
                  , email
                  }: configs // {
          "${hostname}" = darwin.lib.darwinSystem rec {
            inherit system;
            inputs = { inherit darwin; };
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
              overlays = [
                (self: super: { helix = helix.defaultPackage."${system}"; })
                (self: super: { deploy-rs = deploy-rs.defaultPackage."${system}"; })
              ];
            };
            modules = [
              ./config/darwin.nix
              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users."${username}" = import ./home/user.nix {
                  inherit pkgs username name email;
                };
              }
            ];
          };
        })
        { }
        darwinSystems;
    };
}
