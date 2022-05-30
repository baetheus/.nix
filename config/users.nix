{ ... }: {
  users.mutableUsers = false;

  users.users.brandon = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH26soDnOC7jeIiaG65Vur93mFRbQipNZiWHd95ZF+TB brandon@neumann"
    ];
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
