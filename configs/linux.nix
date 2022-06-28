{ ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.enableEmergencyMode = false;
  security.sudo.wheelNeedsPassword = false;

  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };
}
