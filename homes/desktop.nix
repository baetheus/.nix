{ pkgs, ... }: {
  home = {
    stateVersion = "21.11";
  };

  programs = {
    home-manager.enable = true;
  };

  imports = [
    ./modules/zsh
    ./modules/vim
    ./modules/git

    ./modules/alacritty
    ./modules/zellij
    ./modules/helix
    ./modules/direnv
  ];
}
