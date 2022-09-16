{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ helix rnix-lsp ];
  };

  xdg.configFile = {
    "helix/languages.toml".source = ./languages.toml;
    "helix/config.toml".source = ./config.toml;
  };
}
