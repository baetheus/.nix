{ pkgs, ... }: {
  programs.vim = {
    enable = true;
    plugins = with pkgs; [
      vimPlugins.ale
      vimPlugins.vim-unimpaired
      vimPlugins.vim-noctu
    ];
    extraConfig = builtins.readFile ./vimrc;
  };



}
