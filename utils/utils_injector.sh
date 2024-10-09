if ! source /home/remcostoeten/projects/zsh-setup/utils/_grep-folders-and-files.sh 2>/dev/null; then
  echo -e "\e[31mError: Failed to source _grep-folders-and-files.sh\e[0m"
fi

if ! source /home/remcostoeten/projects/zsh-setup/utils/_task-adder.sh 2>/dev/null; then
  echo -e "\e[31mError: Failed to source _task-adder.sh\e[0m"
fi
