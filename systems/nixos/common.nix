{ pkgs, ... }: {
  # Bootloader should get a module
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.enableEmergencyMode = false;
  security.sudo.wheelNeedsPassword = false;

  i18n.defaultLocale = "en_US.UTF-8";

  # Cute motd on login
  environment.loginShellInit = ''
   # disable for user root and non-interactive tools
   if [ `id -u` != 0 ]; then
     if [ "x''${SSH_TTY}" != "x" ]; then
       ${pkgs.microfetch}/bin/microfetch
     fi
   fi
 '';

}
