{ pkgs, ... }: {
  programs.vim = {
    enable = true;
    plugins = with pkgs; [
      vimPlugins.ale
      vimPlugins.vim-unimpaired
      vimPlugins.vim-commentary
      vimPlugins.vim-noctu
      vimPlugins.vim-ledger

      vimPlugins.vim-dadbod
      vimPlugins.vim-dadbod-ui
      vimPlugins.vim-dadbod-completion
    ];
    extraConfig = builtins.readFile ./vimrc;
  };
}
