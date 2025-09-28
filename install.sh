
#!/usr/bin/env bash
set -e
trap 'echo "Error occurred during installation. Please check the output above."' ERR

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
  wl-clipboard
  imv
  zathura
  tldr
  ncdu
  fd
  ripgrep
  neofetch
  git-delta
  ddcutil
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
  sddm-catppuccin-theme
  exa
  bat
  xplr
  ranger
  lf
  fzf-tab
  starship-preset
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


# Set zsh as the default shell for the current user
chsh -s /bin/zsh "$USER"


# Configure zsh to use starship prompt and oh-my-zsh if not present
if ! grep -q 'eval "$(starship init zsh)"' "$HOME/.zshrc"; then
  echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
fi
if ! [ -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
fi


# Set Catppuccin theme for SDDM if installed
if [ -d "/usr/share/sddm/themes/catppuccin" ]; then
  sudo sed -i 's/^Current=.*/Current=catppuccin/' /etc/sddm.conf
fi



# Print summary and error handling
echo "\nNoctalia + Hyprland desktop setup complete!\n"
echo "- Noctalia will start automatically with your session via systemd."
echo "- Nautilus is set as your default file manager."
echo "- Zsh is your default shell, configured with Starship and Oh My Zsh."
echo "- Catppuccin is your SDDM theme."
echo "- Extra CLI tools and utilities installed: bat, exa, fd, ripgrep, ncdu, tldr, imv, zathura, xplr, wl-clipboard."
echo "\nLog out and log back in to enjoy your new environment."
