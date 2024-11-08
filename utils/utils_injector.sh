if ! source /home/remcostoeten/projects/zsh-setup/utils/_task-adder.sh 2>/dev/null; then
  echo -e "\e[31mError: Failed to source _task-adder.sh\e[0m"
fi


if ! source /home/remcostoeten/projects/zsh-setup/utils/_print-current-path.sh 2>/dev/null; then
  echo -e "\e[31mError: Failed to source _print-current-path.sh.sh\e[0m"
fi


source /home/remcostoeten/projects/zsh-setup/utils/_print-current-path.sh
