{ me, pkgs, ... }@inputs: {
  home = with me; {
    inherit username;
    stateVersion = "23.05";

    # Use vim as the default editor
    sessionVariables = {
      EDITOR = "vim";
    };

    # System packages I want
    packages = with pkgs; [
      ripgrep # Because I always need it
      tailscale # For remote access
      # SCM
      git 
      fossil
    ];
  };

  programs = {
    home-manager.enable = true;
  };

  imports = [
    (import (../configs/git) inputs)
    ../configs/zsh # Shell
    ../configs/vim # Coding
    ../configs/direnv # Useful for dev environments
  ];
}
