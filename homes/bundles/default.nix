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
      ripgrep # Searching
      yubikey-agent # Logging in
      comma # Not polluting my shell with other stuff
    ];
  };

  programs = {
    home-manager.enable = true;
  };

  imports = [
    (import (../modules/git) inputs) # Coding
    ../modules/zsh # Shell
    ../modules/vim # Coding
    ../modules/zellij # Useful sometimes but mucks with vim
    ../modules/direnv # Useful for dev environments
  ];
}
