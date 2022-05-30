{ nixpkgs, home-manager, nix-darwin, agenix, impermanence, ... }:
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
        ../config/users.nix
        impermanence.nixosModule
        {
          environment.persistence."/persist" = {
            hideMounts = true;
            directories = [
              "/var/log"
              "/var/lib/systemd/coredump"
              "/run/agenix.d"
            ];
            files = [
              "/etc/machine-id"
              { file = "/etc/nix/ssh_host_ed25519_key"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
              { file = "/etc/nix/ssh_host_ed25519_key.pub"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
              { file = "/etc/nix/ssh_host_rsa_key"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
              { file = "/etc/nix/ssh_host_rsa_key.pub"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
            ];
            users.brandon = {
              directories = [
                { directory = ".ssh"; mode = "0700"; }
              ];
            };
          };
        }
        agenix.nixosModule
        {
          age.identityPaths = [ "/persist/home/brandon/.ssh/id_ed25519" ];
        }
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
