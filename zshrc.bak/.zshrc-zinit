# System Proxy
# export ALL_PROXY=127.0.0.1:7890
# export HTTP_PROXY=192.168.0.108:8899
# export HTTPS_PROXY=192.168.0.108:8899
# export SOCKS5_PROXY=192.168.0.108:9988

######## Zinit Setup ########
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
#############################

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Common Configuration
  # zsh plugins
  zi light z-shell/H-S-MW
  zi light zsh-users/zsh-completions
  zi light zdharma/fast-syntax-highlighting
  # zi light zsh-users/zsh-syntax-highlighting
  zi light zsh-users/zsh-autosuggestions

  # exa is not maintained and mv to eza
  # zi light DarrinTisdale/zsh-aliases-exa
  zi light z-shell/zsh-eza
  # zi light Aloxaf/fzf-tab

####### oh my zsh snippets #######
####################################
# zinit snippet <URL>        # Raw Syntax with URL
# zinit snippet OMZ::<PATH>  # Shorthand OMZ/ (https://github.com/ohmyzsh/ohmyzsh/raw/master/)
# zinit snippet OMZL::<PATH> # Shorthand OMZ/lib/
# zinit snippet OMZT::<PATH> # Shorthand OMZ/themes/
# zinit snippet OMZP::<PATH> # Shorthand OMZ/plugins/
####################################
  # Must Load OMZ Git library
  zi snippet OMZL::git.zsh

  # Load Git plugin from OMZ
  zi snippet OMZP::git
  zi snippet OMZP::urltools
  zi cdclear -q # <- forget completions provided up to this moment

  zi snippet OMZL::clipboard.zsh		    # without omz_urlencode
  zi snippet OMZL::completion.zsh
  zi snippet OMZL::history.zsh
  zi snippet OMZL::key-bindings.zsh	    # without omz_urlencode
  zi snippet OMZL::theme-and-appearance.zsh   # without omz_urlencode
  zi snippet OMZL::functions.zsh
  zi snippet OMZL::termsupport.zsh	    # with omz_urlencode

  zi snippet OMZP::dotenv
  zi snippet OMZP::rake
  zi snippet OMZP::rbenv
  zi snippet OMZP::ruby
  zi snippet OMZP::autojump
  zi snippet OMZP::pip
  zi snippet OMZP::sublime
  zi snippet OMZP::sudo
  zi snippet OMZP::rails
  zi snippet OMZP::textmate
  zi snippet OMZP::lighthouse
  zi snippet OMZP::gitignore
  zi snippet OMZP::colored-man-pages
  zi snippet OMZP::cp
  zi snippet OMZP::brew
  zi snippet OMZP::npm
  # zi snippet OMZP::tmux

#zsh自动填充
  setopt AUTO_PUSHD

# 一些指令重写
# alias egrep='egrep --color=auto'
# alias fgrep='fgrep --color=auto'
# alias grep='grep --color=auto'

alias ra='ranger'
eval $(thefuck --alias)

# Spcific configuration
  os=$(uname)

  # MacOS
  if [[ $os == "Darwin" ]]; then
    export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-18.0.2.jdk/Contents/Home
    # export PATH="/opt/homebrew/Cellar/node@16/bin:$PATH"
    export PATH="/opt/homebrew/Cellar/node/21.7.1/bin:$PATH"
    export EDITOR=/opt/homebrew/bin/nvim
  elif [ "$os" = "Linux" ]; then

  fi