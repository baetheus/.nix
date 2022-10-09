{ me, pkgs, ... }@inputs: {
  home = with me; {
    inherit username;
    stateVersion = "22.05";

    # Use vim as the default editor
    sessionVariables = {
      EDITOR = "vim";
    };

    # System packages I want
    packages = with pkgs; [
      ripgrep # Because I always need it
      tailscale # For remote access
    ];
  };

  programs = {
    home-manager.enable = true;
  };

  imports = [
    (import (../configs/git) inputs) # Coding
    ../configs/zsh # Shell
    ../configs/vim # Coding
    ../configs/zellij # Useful sometimes but mucks with vim
    ../configs/direnv # Useful for dev environments
  ];
}
