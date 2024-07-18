#!/bin/bash

############ COLOURED BASH TEXT

# ANSI color codes
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

###############################

# Update the package database
sudo pacman -Sy

# Detect the GPU
GPU=$(lspci | grep -E "VGA|3D")

# Function to install NVIDIA drivers
install_nvidia_drivers() {
    echo -e "${YELLOW} NVIDIA GPU detected. Installing NVIDIA drivers... ${NC}"
    sudo pacman -S --noconfirm nvidia nvidia-utils lib32-nvidia-utils vulkan-icd-loader lib32-vulkan-icd-loader
}

# Function to install AMD drivers
install_amd_drivers() {
    echo -e "${YELLOW} AMD GPU detected. Installing AMD drivers... ${NC}"
    sudo pacman -S --noconfirm xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
}

# Function to install Intel drivers (optional, in case the system has integrated Intel graphics)
install_intel_drivers() {
    echo -e "${YELLOW} INTEL GPU detected. Installing INTEL drivers... ${NC}"
    sudo pacman -S --noconfirm xf86-video-intel mesa lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
}

# Determine which drivers to install
if echo "$GPU" | grep -i nvidia > /dev/null; then
    install_nvidia_drivers
elif echo "$GPU" | grep -i amd > /dev/null; then
    install_amd_drivers
elif echo "$GPU" | grep -i intel > /dev/null; then
    install_intel_drivers
else
    echo -e "${RED} No supported GPU detected or GPU detection failed. ${NC}"
    exit 1
fi

echo -e "${YELLOW} Installing mesa-utils & vulkan-tools. ${NC}"
# Optional: Install additional common packages
sudo pacman -S --noconfirm mesa-utils vulkan-tools

echo -e "${GREEN} DRIVER INSTALLATION COMPLETE. ${NC}"
