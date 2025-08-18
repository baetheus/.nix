{ pkgs, ... }: {
  programs.vim = {
    enable = true;
    plugins = with pkgs; [
      # Generic Plugins
      vimPlugins.vim-unimpaired
      vimPlugins.vim-commentary
      vimPlugins.vim-noctu

      # Life Plugins
      vimPlugins.vim-ledger
      vimPlugins.vim-orgmode

      # Programming Plugins
      vimPlugins.ale
      vimPlugins.vim-dadbod
      vimPlugins.vim-dadbod-ui
      vimPlugins.vim-dadbod-completion
    ];
    extraConfig = builtins.readFile ./vimrc;
  };
}
