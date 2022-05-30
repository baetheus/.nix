#!/bin/sh

# Local disks
export disk=(/dev/disk/by-id/ata-HGST_HUS726020ALA610_K5GN8DTA /dev/disk/by-id/ata-HGST_HUS726020ALA610_K5H89T4A /dev/disk/by-id/ata-HGST_HUS726020ALA610_K5HU123F /dev/disk/by-id/ata-HGST_HUS726020ALA610_K5J3EZEG)

# Partition disks
for x in "${disk[@]}"; do
  sgdisk --zap-all "$x"
  parted "$x" -- mklabel gpt
  # Root
  parted "$x" -- mkpart primary 512MiB 100%

  # EFI/Boot
  parted "$x" -- mkpart ESP fat32 1MiB 512MiB
  parted "$x" -- set 2 esp on

  sleep 2

  mkfs.fat -F 32 -n EFI "${x}-part2"
done

# Probe disks
partprobe

# Create zpool
zpool create \
  -o ashift=12 \
  -o autotrim=on \
  -R /mnt \
  -O canmount=off \
  -O mountpoint=none \
  -O acltype=posixacl \
  -O compression=zstd \
  -O dnodesize=auto \
  -O normalization=formD \
  -O relatime=on \
  -O xattr=sa \
  -f \
  pool \
  raidz1 \
  "${disk[@]/%/-part1}"

# Create datasets
zfs create -o refreservation=1G -o mountpoint=none pool/reserved
zfs create -o canmount=on -o mountpoint=/nix pool/nix
zfs create -o canmount=on -o mountpoint=/persist pool/persist

# Mount boot partitions
mkdir /mnt/boot{,2,3,4}
mount "${disk[0]}-part2" /mnt/boot
mount "${disk[1]}-part2" /mnt/boot2
mount "${disk[2]}-part2" /mnt/boot3
mount "${disk[3]}-part2" /mnt/boot4

# Geeneratee nix config
nixos-generate-config --root /mnt
