inputs:
let
  # A collection of profiles 
  profiles = import ./profiles.nix;

  # A collection of bundles (home-manager modules)
  bundles = {
    default = import ./bundles/default.nix;
    work = import ./bundles/work.nix;
    server = import ./bundles/server.nix;
  };

  # Make a module for nixos or nix-darwin
  mkHomeModule = { me, bundle }: {
    home-manager.users."${me.username}" = bundle { inherit me; };
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
  inherit homes;

  # I don't currently use home-manager outside
  # of nixos or nix-darwin configurations, but if
  # I start to do that I would put
  # homeConfigurations here.

  # homeConfigurations.brandon = ...

}
