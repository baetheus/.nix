{ pkgs, ... }: {
  programs.vim = {
    enable = true;
    plugins = with pkgs; [
      vimPlugins.ale
      vimPlugins.vim-unimpaired
    ];
    extraConfig = builtins.readFile ./vimrc;
  };

}
