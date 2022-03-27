{ pkgs, ... }:

{
  home = {
    username = "brandon";
    stateVersion = "21.11";

    sessionVariables = {
      EDITOR = "vim";
    };

    packages = with pkgs; [
      deno
      kubectl
      lima
      ripgrep
    ];
  };

  programs = {
    home-manager.enable = true;

    zsh = import ./lib/zsh.nix;

    vim = import ./lib/vim.nix { inherit pkgs; };

    git = import ./lib/git.nix {
      name = "Brandon Blaylock";
      email = "brandon@null.pub";
    };
  };
}
