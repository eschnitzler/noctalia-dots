#!/usr/bin/env bash
# Fuzzy finder for installing packages with yay

# Check for fzf and yay
if ! command -v fzf &>/dev/null; then
  echo "fzf is required. Install it with: sudo pacman -S fzf"
  exit 1
fi
if ! command -v yay &>/dev/null; then
  echo "yay is required. Install it first."
  exit 1
fi

# Get package list from yay (repo + AUR)
pkgs=$(yay -S -lq | awk '{print $1}')

# Fuzzy select one or more packages
selected=$(echo "$pkgs" | fzf --multi --prompt="Install package(s): " --height=80%)

if [[ -z "$selected" ]]; then
  exit 0
fi

yay -S --needed --noconfirm $selected
