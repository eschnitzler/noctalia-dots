
#!/usr/bin/env bash
# Interactive Hyprland keybinds menu with rofi that executes selected command

HYPRCONF="$HOME/.config/hypr/hyprland.conf"

# Parse keybinds: Only lines starting with 'bind ='
mapfile -t binds < <(grep '^bind =' "$HYPRCONF")

menu_entries=()
commands=()

for line in "${binds[@]}"; do
  # Remove 'bind =' and spaces
  line=${line#bind =}
  line=$(echo "$line" | sed 's/^ *//')
  # Split by comma
  IFS=',' read -r mod key action command <<< "$line"
  # Only show exec actions
  if [[ "$action" == "exec" ]]; then
    # Make readable label
    label="[$mod+$key] → $command"
    menu_entries+=("$label")
    commands+=("$command")
  fi
done

# Show menu and get selection
selected=$(printf '%s\n' "${menu_entries[@]}" | rofi -dmenu -i -p "Run Hyprland Keybind" -no-custom)

# Find index of selection
for i in "${!menu_entries[@]}"; do
  if [[ "${menu_entries[$i]}" == "$selected" ]]; then
    exec_cmd="${commands[$i]}"
    break
  fi
done

# Run the command if found
if [[ -n "$exec_cmd" ]]; then
  eval "$exec_cmd" &
fi
