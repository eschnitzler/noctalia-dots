
# noctalia-dots

Automated installer and configuration for Noctalia and Hyprland on Arch Linux.

## Features
- Installs Noctalia using official scripts
- Customizes Hyprland configuration for a clean setup
- Adds recommended dependencies and utilities
- Modern CLI tools: bat, exa, fd, ripgrep, ncdu, tldr, imv, zathura, xplr, wl-clipboard, neofetch, git-delta, ranger, lf, fzf-tab, starship-preset
- Fuzzy package installer and keybind helper scripts
- Oh My Zsh + Starship prompt for a beautiful shell
- Catppuccin SDDM theme
- Dotfiles backup and update scripts

## Usage
Run the install script:

```bash
bash install.sh
```

### Backup your dotfiles
```bash
~/.config/scripts/backup_dotfiles.sh
```

### Update all packages and dotfiles
```bash
~/.config/scripts/update_all.sh
```

## References
- [Noctalia Documentation](https://docs.noctalia.dev/docs/)
- [Noctalia Shell GitHub](https://github.com/noctalia-dev/noctalia-shell)

## Troubleshooting
- If you encounter errors, check the output above or run the install script again.
- For Wayland quirks or SDDM theme issues, see the Noctalia docs.
