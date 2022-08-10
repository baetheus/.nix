{ pkgs, ... }: {
  programs.zellij = {
    enable = true;
    settings = {
      simplified_ui = true;
    };
  };
}
