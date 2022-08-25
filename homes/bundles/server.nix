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
    ../modules/zellij
    ../modules/vim
  ];
}
