# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set up Powerlevel10k theme
if [ -f /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme ]; then
    source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme
elif [ -f /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme ]; then
    source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
elif [ -f ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme ]; then
    source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Recommended font: MesloLGS NF
# Terminal colors and other theme settings
export TERM="xterm-256color" 