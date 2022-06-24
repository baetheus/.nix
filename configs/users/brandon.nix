{ pkgs, ... }: {
  users.mutableUsers = false;

  users.users.brandon = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH26soDnOC7jeIiaG65Vur93mFRbQipNZiWHd95ZF+TB brandon@hopper"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBajlplZeTASyUqnPJVrmkX3eyWT5I3JhwEWiDsV7NH1 brandon@shared"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJrUIIRoOgUoPZ17KzBE5MuI5kq/LvUnO7Sw3wVdbzhB brandon@rosalind"
    ];
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };
}
