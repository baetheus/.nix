{ me, ... }@inputs: {
  home = with me; {
    inherit username;
    stateVersion = "22.05";

    # Use vim as the default editor
    sessionVariables = {
      EDITOR = "vim";
    };
  };

  programs = {
    home-manager.enable = true;
  };

  imports = [
    (import (../configs/git) inputs)
    ../configs/zsh
    ../configs/zellij
    ../configs/vim
  ];
}
