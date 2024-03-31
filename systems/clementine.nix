{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware/clementine.nix
    ./common/minimal.nix
  ];

  # General
  system.stateVersion = "24.05";

  # Networking
  networking.hostName = "clementine";
  networking.hostId = "1de212b8";
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [];

  # Boot
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # Disks
  disko.devices = {
    disk.sda = {
      type = "disk";
      device = "/dev/disk/by-id/wwn-0x5000cca24bc0981d";
      content = {
        type = "gpt";
        partitions = {
          BOOT = {
            size = "1M";
            type = "EF02"; # for grub MBR
          };
          ESP = {
            size = "500M";
            type = "EF00";
            content = {
              type = "mdraid";
              name = "boot";
            };
          };
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
        };
      };
    };
    disk.sdb = {
      type = "disk";
      device = "/dev/disk/by-id/wwn-0x5000cca24bc6ce77";
      content = {
        type = "gpt";
        partitions = {
          BOOT = {
            size = "1M";
            type = "EF02"; # for grub MBR
          };
          ESP = {
            size = "500M";
            type = "EF00";
            content = {
              type = "mdraid";
              name = "boot";
            };
          };
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
        };
      };
    };
    mdadm = {
      boot = {
        type = "mdadm";
        level = 1;
        metadata = "1.0";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        mode = "mirror";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "true";
        };
        mountpoint = "/";
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";

        datasets = {
          nix = {
            type = "zfs_fs";
            options.mountpoint = "/nix";
            options."com.sun:auto-snapshot" = "false";
          };
        };
      };
    };
  };

  # Services
  services.openssh.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
}
