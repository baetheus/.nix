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
  environment.systemPackages = with pkgs; [
    firefox
  ];

  # Audio
  sound.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Control,Gateway,Headset,Media,Sink,Socket,Source";
      MultiProfile = "multiple";
    };
  };
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

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
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.autoLogin.relogin = true;
  services.xserver.displayManager.sddm.settings = {
    Autologin = {
      Session = "plasma.desktop";
      User = "brandon";
    };
  };

  # Synergy
  services.synergy.client = {
    enable = true;
    serverAddress = "192.168.86.21";
  };

  # Plex
  services.plex = {
    enable = true;
    openFirewall = true;
  };
}

