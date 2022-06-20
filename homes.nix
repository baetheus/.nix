inputs:
let
  inherit (import ./utils.nix inputs) mkSimpleHome;
  eachDefaultSystem = inputs.flake-utils.lib.eachDefaultSystem;
in
eachDefaultSystem (system: {
  brandon = mkSimpleHome {
    inherit system;
    username = "brandon";
    name = "Brandon Blaylock";
    email = "brandon@null.pub";
  };

  brandonblaylock = mkSimpleHome {
    inherit system;
    username = "brandonblaylock";
    name = "Brandon Blaylock";
    email = "bblaylock@cogility.com";
  };
})
