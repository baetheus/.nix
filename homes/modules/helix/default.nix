{ pkgs, ... }: {
  # Use helix as the default editor
  sessionVariables = {
    EDITOR = "hx";
  };

  packages = with pkgs; [ helix rnix-lsp ];

  xdg.configFile = {
    "helix/languages.toml".source = /languages.toml;
    "helix/config.toml".source = ./config.toml;
  };
}
