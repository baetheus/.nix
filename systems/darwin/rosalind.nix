{ pkgs, ... }: {
  system.stateVersion = 5;

  environment.systemPackages = with pkgs; [
    bitwarden
    terminator
  ];
}
