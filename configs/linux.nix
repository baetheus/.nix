{ ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/";

  systemd.enableEmergencyMode = false;
  security.sudo.wheelNeedsPassword = false;

  i18n.defaultLocale = "en_US.UTF-8";

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };
}
