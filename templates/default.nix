inputs: {
  templates = {
    # The default template only sets up a devshell with no packages
    default = {
      path = ./default;
      description = "nix flake new -t github:baetheus/.nix .";
    };
  };
}
