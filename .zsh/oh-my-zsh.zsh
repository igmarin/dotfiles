# Oh-my-zsh configuration
ZSH_THEME="robbyrussell"
zstyle ':omz:update' mode auto
DISABLE_MAGIC_FUNCTIONS="true"
plugins=(git)
source $ZSH/oh-my-zsh.sh
unalias gga 2>/dev/null
