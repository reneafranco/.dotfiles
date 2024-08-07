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

# Install additional packages
echo "Installing additional packages..."
yay -S --noconfirm xorg xorg-init picom alacritty i3-wm i3blocks i3-gaps autotiling dmenu neofetch nitrogen firefox npm nvim || error_exit "Error: Could not install additional packages."

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

# Install getnf
echo "Installing getnf..."
yay -S --noconfirm getnf || error_exit "Error: Could not install getnf."

# Install zsh
if ! command -v zsh &> /dev/null; then
    echo "Installing zsh..."
    sudo pacman -S --noconfirm zsh || error_exit "Error: Could not install zsh."
else
    echo "zsh is already installed."
fi

# Install zsh-syntax-highlighting-git using yay
echo "Installing zsh-syntax-highlighting-git..."
yay -S --noconfirm zsh-syntax-highlighting-git || error_exit "Error: Could not install zsh-syntax-highlighting-git."

# Remove existing i3, nvim, and alacritty configurations
echo "Removing existing i3, nvim, and alacritty configurations..."
rm -rf "$HOME/.config/i3" "$HOME/.config/nvim" "$HOME/.config/alacritty" || error_exit "Error: Could not remove existing i3, nvim, and alacritty configurations."

# Create symbolic links
echo "Creating symbolic links for i3, nvim, and alacritty configurations..."
ln -s "$DOTFILES_DIR/i3" "$HOME/.config/i3" || error_exit "Error: Could not create symbolic link for i3."
ln -s "$DOTFILES_DIR/nvim" "$HOME/.config/nvim" || error_exit "Error: Could not create symbolic link for nvim."
ln -s "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty" || error_exit "Error: Could not create symbolic link for alacritty."

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

echo "All tasks completed successfully."

