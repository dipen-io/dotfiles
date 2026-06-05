#!/bin/bash

INSTALL_DIR="/opt"
DISCORD_DIR="$INSTALL_DIR/discord"
URL="https://discord.com/api/download?platform=linux&format=tar.gz"
TMP="/tmp/discord.tar.gz"

echo "Downloading latest Discord..."
curl -L "$URL" -o "$TMP"

echo "Removing old version..."
sudo rm -rf "$DISCORD_DIR"

echo "Installing to /opt..."
sudo tar -xzf "$TMP" -C "$INSTALL_DIR"

sudo mv /opt/Discord "$DISCORD_DIR"

rm "$TMP"

echo "Discord installed/updated successfully!"
