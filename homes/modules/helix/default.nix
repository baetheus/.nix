{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ helix rnix-lsp ];

    # Use helix as the default editor
    sessionVariables = {
      EDITOR = "hx";
    };
  };

  xdg.configFile = {
    "helix/languages.toml".source = ./languages.toml;
    "helix/config.toml".source = ./config.toml;
  };
}
