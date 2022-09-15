{ pkgs, ... }: {
  programs.vim = {
    enable = true;
    plugins = with pkgs; [
      vimPlugins.ale
      vimPlugins.vim-unimpaired
      vimPlugins.vim-commentary
      vimPlugins.vim-noctu
    ];
    extraConfig = builtins.readFile ./vimrc;
  };
}
