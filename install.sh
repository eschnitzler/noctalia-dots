
#!/usr/bin/env bash
set -e

# Install yay (AUR helper) if missing
if ! command -v yay &>/dev/null; then
  echo "==> Installing yay (AUR helper)"
  sudo pacman -S --needed --noconfirm git base-devel
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
fi


# Official repo packages
PACMAN_PKGS=(
  pipewire wireplumber
  xdg-desktop-portal xdg-desktop-portal-hyprland
  qt5-wayland qt6-wayland
  noto-fonts ttf-roboto inter-font
  nerd-fonts
  brightnessctl
  cava
  wlsunset
  nautilus
  btop
  zsh
  wlr-randr
)

# AUR packages
AUR_PKGS=(
  noctalia-shell
  cliphist
  matugen
  nvim
  lazygit
  lazydocker
  pass
  wlr-randr-gtk
  google-chrome
)

# Install yay (AUR helper) if missing
if ! command -v yay &>/dev/null; then
  echo "==> Installing yay (AUR helper)"
  sudo pacman -S --needed --noconfirm git base-devel
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
fi

# Install official repo packages
sudo pacman -Syu --needed --noconfirm "${PACMAN_PKGS[@]}"

# Install AUR packages
yay -S --needed --noconfirm "${AUR_PKGS[@]}"

# Setup dotfiles with stow
cd dotfiles
for dir in */; do
  stow -v --target="$HOME/.config" "$dir"
done
cd ..

# Create systemd user service for noctalia-shell
mkdir -p "$HOME/.config/systemd/user"
cat > "$HOME/.config/systemd/user/noctalia.service" <<EOF
[Unit]
Description=Noctalia Shell Service
PartOf=graphical-session.target
After=graphical-session.target

[Service]
ExecStart=qs -c noctalia-shell
Restart=on-failure
RestartSec=1

[Install]
WantedBy=graphical-session.target
EOF

# Enable and start the service
systemctl --user daemon-reload
systemctl --user enable --now noctalia.service


# Set Nautilus as the default file manager
xdg-mime default org.gnome.Nautilus.desktop inode/directory


# Set Nautilus as the default file manager
xdg-mime default org.gnome.Nautilus.desktop inode/directory

# Set zsh as the default shell for the current user
chsh -s /bin/zsh "$USER"

# Configure zsh to use starship prompt
if ! grep -q 'eval "$(starship init zsh)"' "$HOME/.zshrc"; then
  echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
fi

# Print success message
echo "\nNoctalia + Hyprland desktop setup complete! Noctalia will now start automatically with your session via systemd. Nautilus is now set as your default file manager. Zsh is now your default shell and is configured to use the Starship prompt. Log out and log back in to enjoy your new environment."
