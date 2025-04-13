files_to_source+=(
    "_env.yabai.sh"
    "_env.docker-tool.sh"
)

for file in "${files_to_source[@]}"; do
  source "./${DOTFILES_PATH}/${file}"
done
