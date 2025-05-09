#!/usr/bin/env bash

# Minimal NTFS Mount Script - Read-Write with User Access

# --- Configuration ---
DEVICES=("/dev/sda1" "/dev/sda2" "/dev/sda3" "/dev/sda4")             # Add your NTFS device paths
MOUNT_POINTS=("/mnt/one" "/mnt/two" "/mnt/three/" "/mnt/four/")          # Corresponding mount points
# --- End Configuration ---

# Check ntfs-3g is installed
command -v ntfs-3g >/dev/null || { echo "ntfs-3g not found. Install it first."; exit 1; }

# Check arrays match
[ ${#DEVICES[@]} -eq ${#MOUNT_POINTS[@]} ] || { echo "Mismatch in device/mount point count."; exit 1; }

# Get current user UID and GID
USER_UID=$(id -u)
USER_GID=$(id -g)

for i in "${!DEVICES[@]}"; do
    DEV="${DEVICES[$i]}"
    MNT="${MOUNT_POINTS[$i]}"

    echo "Mounting $DEV at $MNT..."

    sudo mkdir -p "$MNT"
    sudo mount -t ntfs-3g -o rw,uid=$USER_UID,gid=$USER_GID,dmask=022,fmask=133 "$DEV" "$MNT" \
        && echo "Mounted successfully." \
        || echo "Failed to mount $DEV"
done
