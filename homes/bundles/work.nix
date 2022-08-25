{ me, ... }@inputs: {
  home = with me; {
    inherit username;
    stateVersion = "22.05";
  };

  programs = {
    home-manager.enable = true;
  };

  imports = [
    (import (../modules/git) inputs)
    ../modules/zsh
    ../modules/vim

    ../modules/alacritty
    ../modules/zellij
    ../modules/helix
    ../modules/direnv
  ];
}
