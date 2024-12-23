## 1) clone repo `git clone https://github.com/wting/autojump.git`
## 2) cd autojump; python install.python
## 3) source this in ~/.zshrc

[[ -s /home/remcostoeten/.autojump/etc/profile.d/autojump.sh ]] && source /home/remcostoeten/.autojump/etc/profile.d/autojump.sh

autoload -U compinit && compinit -u
