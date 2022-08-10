{ config, pkgs, ... }: {
  imports = [
    ../hardware/sys-1-sat-32.nix
    ../modules/zfs.nix
    ../modules/minimal.nix
    ../modules/age.nix
    ../modules/nix/nixos.nix
    ../modules/openssh.nix
    ../users/brandon.nix
  ];
}
