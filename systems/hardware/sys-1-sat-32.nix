# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Mirrored Boots!?
  # Gotta setup replication somehow
  fileSystems."/boot" = {
    device = "/dev/sda2";
    fsType = "vfat";
    options = [ "nofail" ];
  };

  fileSystems."/boot2" = {
    device = "/dev/sdb2";
    fsType = "vfat";
    options = [ "nofail" ];
  };

  fileSystems."/boot3" = {
    device = "/dev/sdc2";
    fsType = "vfat";
    options = [ "nofail" ];
  };

  fileSystems."/boot4" = {
    device = "/dev/sdd2";
    fsType = "vfat";
    options = [ "nofail" ];
  };

  # Standard Filesystems
  fileSystems."/" = {
    device = "pool/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "pool/nix";
    fsType = "zfs";
  };

  # We don't swap
  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
