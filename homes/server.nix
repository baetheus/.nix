{ more, ... }: {
  home = with more; {
    inherit username;
    stateVersion = "22.05";
  };

  programs = {
    home-manager.enable = true;
  };

  imports = [
    ./modules/zsh
    ./modules/vim
    ./modules/git
  ];
}
