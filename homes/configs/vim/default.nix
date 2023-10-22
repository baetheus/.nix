{ pkgs, ... }: {
  programs.vim = {
    enable = true;
    plugins = with pkgs; [
      vimPlugins.ale
      vimPlugins.vim-unimpaired
      vimPlugins.vim-commentary
      vimPlugins.vim-noctu
      vimPlugins.vim-ledger
    ];
    extraConfig = builtins.readFile ./vimrc;
  };
}
