{ pkgs, ... }: {
  enable = true;

  plugins = [
    pkgs.vimPlugins.ale
    pkgs.vimPlugins.vim-unimpaired
  ];

  extraConfig = builtins.readFile ./files/vimrc;
}
