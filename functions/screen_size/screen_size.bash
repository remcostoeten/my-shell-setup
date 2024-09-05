set_screen_scale() {
  local scale=$(echo "scale=2; $1/100" | bc)
  gsettings set org.gnome.desktop.interface text-scaling-factor $scale
}

alias screen="set_screen_scale"
