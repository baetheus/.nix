{ pkgs, username, name, email, ... }:

{
  home = {
    inherit username;
    stateVersion = "21.11";

    sessionVariables = {
      EDITOR = "vim";
    };

    packages = with pkgs; [
      zellij
      nerdfonts
      helix
      ripgrep

      # Certificate tools
      mkcert
      nssTools

      # Kafka
      apacheKafka

      # TypeScript
      deno
      yarn
      nodejs
      nodePackages.npm
      nodePackages.typescript

      # Nix
      rnix-lsp

      # Rust
      rustup
      rust-analyzer
      wasm-pack
    ];
  };

  programs = {
    home-manager.enable = true;
    zsh = import ./zsh.nix;
    vim = import ./vim.nix { inherit pkgs; };
    git = import ./git.nix { inherit name email; };
  };
  
  xdg.configFile = {
    "alacritty.yml".source = ./files/alacritty.yml;
  };  
}
