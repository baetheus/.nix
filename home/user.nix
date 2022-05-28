{ pkgs, username, name, email, ... }:

{
  home = {
    inherit username;
    stateVersion = "21.11";

    sessionVariables = {
      EDITOR = "vim";
    };

    packages = with pkgs; [
      helix
      rnix-lsp
      deno
      ripgrep
      deploy-rs
      kubectl
    ];
  };

  programs = {
    home-manager.enable = true;
    zsh = import ./zsh.nix;
    vim = import ./vim.nix { inherit pkgs; };
    git = import ./git.nix { inherit name email; };
  };

  xdg.configFile = {
    "helix/languages.toml".source = ./files/languages.toml;
  };
}
