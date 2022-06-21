{ pkgs, username, name, email, ... }:

{
  home = {
    inherit username;
    stateVersion = "21.11";

    sessionVariables = {
      EDITOR = "hx";
    };

    packages = with pkgs; [
      # General Environment
      helix
      zellij
      ripgrep

      # Language Servers
      rnix-lsp

      # Virtual Machines
      deno
    ];
  };

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    zsh = import ./zsh.nix;
    vim = import ./vim.nix { inherit pkgs; };
    git = import ./git.nix { inherit name email; };
  };

  xdg.configFile = {
    "helix/languages.toml".source = ./files/helix/languages.toml;
    "helix/config.toml".source = ./files/helix/config.toml;
    "alacritty/alacritty.yml".source = ./files/alacritty.yml;
    "zellij/config.yaml".source = ./files/zellij/config.yaml;
  };
}
