{ config, pkgs, ... }:

{
  imports = [
    ./hardware/clementine.nix
    ./common/minimal.nix
  ];

  # General
  system.stateVersion = "24.05";

  # Networking
  networking.hostName = "clementine";
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [];

  # Boot
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      {
        devices = [ "/dev/disk/by-id/wwn-0x5000cca24bc0981d" ];
        path = "/boot1";
      }
      {
        devices = [ "/dev/disk/by-id/wwn-0x5000cca24bc6ce77" ];
        path = "/boot2";
      }

    ];
  };

  # Disks
  disko.devices = {
    disk.sda {
      type = "disk";
      device = "/dev/disk/by-id/wwn-0x5000cca24bc0981d";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "64M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot1";
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
          ESP = {
            size = "64M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot2";
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
    zpool = {
      zroot = {
        type = "zpool";
        mode = "mirror";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        mountpoint = "/";
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";

        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
            options."com.sun:auto-snapshot" = "true";
          };
          nix = {
            type = "zfs_fs";
            options.mountpoint = "/nix";
          };
        };
      };
    };
  };

  # Services
  services.openssh.enable = true;
}
