#!/bin/bash

set -e

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

THEME_DIR="."
GRUB_THEME_PATH="/boot/grub/themes"
GRUB_CONFIG="/etc/default/grub"

# Check if a GRUB configuration file exists
if [ ! -f "$GRUB_CONFIG" ]; then
    echo "GRUB configuration file not found. Please make sure GRUB is installed."
    exit 1
fi

read -p "Enter background filename (or press enter to use default): " filename

# Set the default filename if the user didn't provide one
filename=${filename:-1.png}

# Add logog to selected background
python3 create_bg.py "$filename"

# Check if the provided directory exists
if [ ! -d "$THEME_DIR" ]; then
    echo "The directory $THEME_DIR does not exist."
    exit 1
fi

# Create the themes directory if it doesn't exist
if [ ! -d "$GRUB_THEME_PATH" ]; then
    mkdir -p "$GRUB_THEME_PATH"
fi

THEME_NAME=$(basename "$(pwd)")

# Copy the theme to the GRUB themes directory
mkdir -p "$GRUB_THEME_PATH/$THEME_NAME" && cp -r "$THEME_DIR"/* "$GRUB_THEME_PATH/$THEME_NAME/"

# Update the GRUB configuration to use the new theme
sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"$GRUB_THEME_PATH/$THEME_NAME/theme.txt\"|" "$GRUB_CONFIG"

# Update GRUB
echo "Updating GRUB..."
grub-mkconfig -o /boot/grub/grub.cfg

echo "GRUB theme installed successfully."
