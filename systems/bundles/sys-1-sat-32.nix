{ config, pkgs, ... }: {
  imports = [
    ../hardware/sys-1-sat-32.nix
    ../modules/innernet.nix
    ../common/minimal.nix
    ../nixos/zfs.nix
    ../nixos/common.nix
    ../nixos/age.nix
    ../nixos/openssh.nix
  ];
}
