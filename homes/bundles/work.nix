{ me, ... }: {
  home = with me; {
    inherit username;
    stateVersion = "22.05";
  };

  programs = {
    home-manager.enable = true;
  };

  imports = [
    ../modules/git
    ../modules/zsh
    ../modules/vim

    ../modules/alacritty
    ../modules/zellij
    ../modules/helix
    ../modules/direnv
  ];
}
