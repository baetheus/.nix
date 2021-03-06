{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # General
  system.stateVersion = "22.05"; # Did you read the comment?

  # Networking
  networking.hostName = "toph"; # Define your hostname.
  networking.hostId = "007f0200";
  networking.interfaces.eno1.useDHCP = true;

  # Firewall
  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [ 22 53 631 5353 32400 ];
  networking.firewall.allowedTCPPorts = [ 22 53 631 5353 32400 ];

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

  # Users and Groups
  users = {
    users.media = {
      group = "media";
      isSystemUser = true;
    };
    groups.media = {
      members = [ "media" "brandon" ];
    };
  };

  # Home plex
  services.plex = {
    enable = true;
    user = "media";
    group = "media";
  };
}


