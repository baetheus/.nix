inputs: {
  templates = rec {
    # Simple nix flake with a stdenv.devShell and flake-utils
    simple = {
      path = ./simple;
      description = "nix flake new -t github:baetheus/.nix#simple .";
    };
    # A nix flake setup for rust
    rust = {
      path = ./rust;
      description = "nix flake new -t github:baetheus/.nix#rust .";
    };
    # A web api and frontend client pair template for TypeScript
    web = {
      path = ./web;
      description = "nix flake new -t github:baetheus/.nix#web .";
    };
  };
}
