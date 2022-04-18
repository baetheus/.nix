{ pkgs, username, name, email, helix, ... }:

{
  home = {
    inherit username;
    stateVersion = "21.11";

    sessionVariables = {
      EDITOR = "vim";
    };

    packages = with pkgs; [
      deno
      helix
      kubectl
      lima
      ripgrep
      helix
    ];
  };

  programs = {
    home-manager.enable = true;

    zsh = import ./zsh.nix;
    vim = import ./vim.nix { inherit pkgs; };
    git = import ./git.nix { inherit name email; };
  };
}
