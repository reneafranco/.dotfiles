#!/bin/bash

# Define variables
DOTFILES_DIR="$HOME/.dotfiles"
REPO_URL="https://github.com/reneafranco/.dotfiles.git"
BUMBLEBEE_REPO_URL="https://aur.archlinux.org/bumblebee-status.git"
YAY_REPO_URL="https://aur.archlinux.org/yay.git"
BUMBLEBEE_STATUS_DIR="$HOME/.config/i3/bumblebee-status"

# Function to print errors and exit
function error_exit {
    echo "$1" >&2
    exit 1
}

# Check if ~/.dotfiles directory exists
if [ -d "$DOTFILES_DIR" ]; then
    echo "$DOTFILES_DIR already exists. Skipping cloning."
else
    echo "Cloning dotfiles repository..."
    git clone "$REPO_URL" "$DOTFILES_DIR" || error_exit "Error: Could not clone dotfiles repository."
fi

# Install yay
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    sudo pacman -S --needed base-devel git || error_exit "Error: Could not install base-devel and git."
    git clone "$YAY_REPO_URL" || error_exit "Error: Could not clone yay repository."
    cd yay || error_exit "Error: Could not change to yay directory."
    makepkg -si || error_exit "Error: Could not build and install yay."
    cd ..
    rm -rf yay
else
    echo "yay is already installed."
fi

# Install SDKMAN
if ! command -v sdk &> /dev/null; then
    echo "Installing SDKMAN..."
    curl -s "https://get.sdkman.io" | bash || error_exit "Error: SDKMAN installation failed."
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    if sdk version &> /dev/null; then
        echo "SDKMAN installed successfully."
    else
        error_exit "Error: SDKMAN installation verification failed."
    fi
else
    echo "SDKMAN is already installed."
fi

# Check and remove existing bumblebee-status
if [ -d "$BUMBLEBEE_STATUS_DIR" ]; then
    echo "$BUMBLEBEE_STATUS_DIR already exists, removing..."
    rm -rf "$BUMBLEBEE_STATUS_DIR" || error_exit "Error: Could not remove existing bumblebee-status directory."
fi

# Clone bumblebee-status repository
echo "Cloning bumblebee-status repository..."
git clone "$BUMBLEBEE_REPO_URL" "$BUMBLEBEE_STATUS_DIR" || error_exit "Error: Could not clone bumblebee-status repository."
cd "$BUMBLEBEE_STATUS_DIR" || error_exit "Error: Could not change to bumblebee-status directory."
makepkg -sicr || error_exit "Error: Could not build and install bumblebee-status."

# Install zsh-syntax-highlighting-git using yay
echo "Installing zsh-syntax-highlighting-git..."
yay -S --noconfirm zsh-syntax-highlighting-git || error_exit "Error: Could not install zsh-syntax-highlighting-git."

# Install autotiling
echo "Installing autotiling..."
yay -S --noconfirm autotiling || error_exit "Error: Could not install autotiling."

echo "All tasks completed successfully."

