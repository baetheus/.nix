{ config, pkgs, ... }:

{
  imports = [
    ./hardware/nuc.nix
    ./common/minimal.nix
    ./nixos/common.nix
    ./nixos/openssh.nix
    ./nixos/tailscale.nix
    ./users/brandon.nix
  ];

  # General
  system.stateVersion = "22.05"; # Did you read the comment?


  # Networking
  networking.hostName = "toph"; # Define your hostname.
  networking.hostId = "007f0200";
  networking.interfaces.eno1.useDHCP = true;

  # Firewall
  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [ 22 53 631 5353 ];
  networking.firewall.allowedTCPPorts = [ 22 53 631 3478 5353 41641 ];

  # Printing
  services.printing.enable = true;
  services.printing.browsing = true;
  services.printing.listenAddresses = [ "*:631" ];
  services.printing.allowFrom = [ "all" ];
  services.printing.defaultShared = true;
  services.printing.drivers = [ pkgs.samsung-unified-linux-driver ];

  # Netatalk (Time Capsule)
  users.users.capsule.group = "capsule";
  users.users.capsule.isSystemUser = true;
  users.groups.capsule.members = [ "capsule" ];

  services.netatalk.enable = true;
  services.netatalk.settings = {
    Global = {
      "server name" = "capsule";
      "uam list" = "uams_guest.so,uams_dhx.so,uams_dhx2.so";
      "mimic model" = "TimeCapsule6,116";
      "guest account" = "capsule";
    };
    capsule = {
      path = "/backup/capsule";
      "time machine" = "yes";
    };
  };

  # Service discovery
  services.avahi.enable = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.domain = true;
  services.avahi.publish.userServices = true;

}
