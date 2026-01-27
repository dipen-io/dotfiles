#!/bin/sh
# Void Linux manual package install script

set -e

echo "==> Syncing XBPS repositories..."
sudo xbps-install -S

echo "==> Enabling nonfree repository..."
sudo xbps-install -y void-repo-nonfree
sudo xbps-install -S

echo "==> Installing user-selected packages..."

sudo xbps-install -y \
ImageMagick \
blueman \
discord \
fastfetch \
ffmpeg \
gvfs \
gvfs-afc \
gvfs-mtp \
ironbar \
kitty \
libbsd \
libcanberra \
libutempter \
libutf8proc \
mesa-dri \
mesa-vulkan-intel \
poppler-utils \
procps-ng \
qemu \
river \
speedtest-cli \
thunderbird \
vlc \
volumeicon \
wireguard-tools \
xcb-util-cursor \
xev \
yazi \
yt-dlp

echo "==> All packages installed successfully 🎉"

