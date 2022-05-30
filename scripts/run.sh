#!/bin/sh

# Select disks
export disks=(`lsblk -dnl -o PATH`);

menuitems() {
    echo "Avaliable disks:"
    for i in ${!disks[@]}; do
        printf "[%s] %2d) %s\n" "${choices[i]:- }" $((i+1)) "${disks[i]}"
    done
    [[ "$msg" ]] && echo "$msg"; :
}

prompt="Select a disk (enter again to uncheck, press RETURN when done): "
while menuitems && read -rp "$prompt" num && [[ "$num" ]]; do
    [[ "$num" != *[![:digit:]]* ]] && (( num > 0 && num <= ${#disks[@]} )) || {
        msg="Invalid option: $num"; continue
    }
    ((num--)); msg="${disks[num]} was ${choices[num]:+un-}selected"
    [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="x"
done

result=()
for i in ${!disks[@]}; do
    [[ "${choices[i]}" ]] && result+=("${disks[i]}");
done


if [[ ${#result[@]} = 0 ]]; then
    echo "No disks selected.. aborting!";
    exit;
fi

echo "\nYou selected:"
for i in ${!result[@]}; do
    echo " - ${result[i]}";
done

# Partition disks
for x in "${result[@]}"; do
  echo "Partitioning $x"
  sgdisk --zap-all "$x"
  parted "$x" -- mklabel gpt
  # Root
  parted "$x" -- mkpart primary 512MiB 100%

  # EFI/Boot
  parted "$x" -- mkpart ESP fat32 1MiB 512MiB
  parted "$x" -- set 2 esp on

  sleep 2

  mkfs.fat -F 32 -n EFI "${x}2"
done

# Probe disks
echo "Probing discs"
partprobe

sleep 2

# Create zpool
if [[ ${#result[@]} = 2 ]]; then
    pool_type="mirror";
elif [[ ${#result[@]} > 2 ]]; then
    pool_type="raidz1";
else
    pool_type="";
fi

echo "Creating pool $pool_type"

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
  "$pool_type" \
  "${result[@]/%/1}"

# Create datasets
echo "Creating datasets"
zfs create -o refreservation=1G -o mountpoint=none pool/reserved
zfs create -o canmount=on -o mountpoint=/ pool/root
zfs create -o canmount=on -o mountpoint=/nix pool/nix

echo "Setting up snapshots"
zfs set com.sun:auto-snapshot=true pool/root

# Mount boot partitions
echo "Mounting boot partitions"

for i in ${!result[@]}; do
    mnt="/mnt/boot"
    if [[ $i != 0 ]]; then
        mnt+="$((i + 1))";
    fi
    mkdir $mnt;
    mount "${result[$i]}2" $mnt;
done

# Generate nix config
echo "Generating nixos configuration templates"
nixos-generate-config --root /mnt

# Some notes for the user
echo "Remember to copy id_ed25519_shared keypair is in /keys"
echo "You can load a flake by running:"
echo "nixos-install --flake github:baetheus/.nix#HOST --root /mnt --max-jobs 8"

