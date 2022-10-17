{ config, pkgs, ... }:

{
  imports = [
    ./hardware/nuc.nix
    ./common/minimal.nix
    ./nixos/zfs.nix
    ./nixos/common.nix
    ./nixos/openssh.nix
    ./nixos/age.nix
    ./nixos/tailscale.nix
  ];

  # Secrets
  age.secrets."tuna-wifi".file = ../secrets/wifi-tuna.age;

  # General
  system.stateVersion = "22.05"; # Did you read the comment?

  # Networking
  networking.hostName = "toph"; # Define your hostname.
  networking.hostId = "007f0200";
  networking.interfaces.eno1.useDHCP = true;
  networking.wireless.enable = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;
  networking.supplicant = {
    "WLAN" = {
      configFile.path = config.age.secrets."tuna-wifi".path;
    };
  };

  # Firewall
  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [ 22 53 631 5353 ];
  networking.firewall.allowedTCPPorts = [ 22 53 631 5353 ];

  # Printing
  services.printing.enable = true;
  services.printing.browsing = true;
  services.printing.listenAddresses = [ "*:631" ];
  services.printing.allowFrom = [ "all" ];
  services.printing.defaultShared = true;
  services.printing.drivers = [ pkgs.samsung-unified-linux-driver ];

  # Service discovery
  services.avahi.enable = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.domain = true;
  services.avahi.publish.userServices = true;
}
 
