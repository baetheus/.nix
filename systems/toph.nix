{ config, pkgs, ... }:

{
  imports = [
    ./hardware/nuc.nix
    ./common/minimal.nix
    ./nixos/common.nix
    ./nixos/openssh.nix
  ];

  # General
  system.stateVersion = "22.05"; # Did you read the comment?
  sound.enable = true;

  # Networking
  networking.hostName = "toph"; # Define your hostname.
  networking.hostId = "007f0200";
  networking.interfaces.eno1.useDHCP = true;

  # Firewall
  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [ 22 53 631 5353 ];
  networking.firewall.allowedTCPPorts = [ 22 53 631 3478 3389 5353 41641 ];

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

  # Window Manager
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # RDP
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";
}
