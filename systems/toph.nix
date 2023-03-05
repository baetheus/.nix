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

  # Syncthing
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    # dataDir = "/home/wk";
    # configDir = "/home/wk/.config/syncthing";
    user = "brandon";
    group = "users";
    guiAddress = "0.0.0.0:8384";
    declarative = {
      overrideDevices = true;
      overrideFolders = true;
      devices = {
        "abigail" = { id = "ABIGAIL-KEY"; };
        "rosalind" = { id = "FU4DRZY-65RNCNZ-CDJXQOS-V2PKRY2-ULGBH4J-Q5AA7GC-WNQ3JFP-PLB6MQW"; };
      };
      folders = {
        "nix" = {
          path = "/home/brandon/.nix";
          devices = [ "abigail" "rosalind" ];
        };
        "src" = {
          path = "/home/brandon/src";
          devices = [ "abigail" "rosalind" ];
        };
        "Documents" = {
          path = "/home/brandon/documents";
          devices = [ "abigail" "rosalind" ];
          versioning = {
            type = "staggered";
            params = {
              cleanInterval = "3600";
              maxAge = "15768000";
            };
          };
        };
      };
    };
  };
};




}
 
