{ pkgs, username, name, email, ... }:

{
  home = {
    inherit username;
    stateVersion = "21.11";

    sessionVariables = {
      EDITOR = "vim";
      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    };

    packages = with pkgs; [
      helix
      ripgrep
      mkcert

      # Kafka
      apacheKafka

      # TypeScript
      deno

      # Nix
      rnix-lsp

      # Rust
      rustc
      cargo
      rust-analyzer
      rustfmt
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
