inputs:
let
  # A collection of profiles 
  profiles = import ./profiles.nix;

  # A collection of bundles (home-manager modules)
  bundles = {
    default = import ./bundles/default.nix;
    server = import ./bundles/server.nix;
  };

  # Make a module for nixos or nix-darwin
  mkHomeModule = { me, bundle }: { pkgs, ... }: {
    home-manager.users."${me.username}" = bundle { inherit me pkgs; };
    users.users."${me.username}" = { };
  };

  # Seeded home modules by profile and bundle
  # ie. homes.brandon.default
  homes = (builtins.mapAttrs
    (_: me: (builtins.mapAttrs
      (_: bundle: mkHomeModule { inherit me bundle; }
      )
      bundles)
    )
    profiles);

in
{
  # Home modules for nixos or nix-darwin
  # seeded 

  # I don't currently use home-manager outside
  # of nixos or nix-darwin configurations, but if
  # I start to do that I would put
  # homeConfigurations here. The first issue to
  # face is that according to
  # https://nix-community.github.io/home-manager/index.html#ch-nix-flakes
  # one must specify pkgs to pull from, which requires
  # setting a system. Thus homeConfigurations is not
  # portable across system architectures unless keyed
  # by a combination of user-system... hopefully this
  # will change in the future.

  # homeConfigurations.brandon = ...
  inherit homes;
}
