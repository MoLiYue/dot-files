COMPANY_MACHINE=0

# 判断是否为公司机器（这里假设 COMPANY_MACHINE=1 表示公司机器）
if [[ "$COMPANY_MACHINE" == "1" ]]; then

  if [ -r /etc/home/zshrc -a -d /env ]; then
   # MWP: use ARC environment
   . /etc/home/zshrc
  elif [ -r $HOME/.zshrc.old ]; then
   # fall back to legacy environment
   . $HOME/.zshrc.old
  fi

#   # 追加公司专用的 MODULEPATH
#   export MODULEPATH="${MODULEPATH}:/app/modules/0/modulefiles:/home/ehexyil/.afs/0/rmodules:/home/ehexyil/.afs/0/pmodules:/env/sero/modules:/env/common/modules"

#   # 加载 Modules 系统的 zsh 初始化脚本
#   source /usr/share/Modules/init/zsh

#   # 定义 module 命令函数（如果没有自动定义）
#   module () {
#       {
#           eval `/app/modules/0/bin/modulecmd zsh "$@"`
#       } 2>&1
#   }

#   # 如果用户目录下存在 .modules 文件，则加载
#   if [[ -f $HOME/.modules ]]; then
#     source $HOME/.modules
#   fi

  # Add ~/bin to PATH if it exists
  if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
  fi

  typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
  export EDITOR=nvim

fi

#############################
# OS Specific Configuration
#############################
os=$(uname)

if [[ $os == "Darwin" ]]; then
  # macOS specific settings
  export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-18.0.2.jdk/Contents/Home"
  # Uncomment the following line if using an older Node version:
  # export PATH="/opt/homebrew/Cellar/node@16/bin:$PATH"
  export PATH="/opt/homebrew/Cellar/node/21.7.1/bin:$PATH"
  export EDITOR="/opt/homebrew/bin/nvim"
elif [[ $os == "Linux" ]]; then
  # Linux specific settings (add your Linux configurations here)

  # archlinux setup pyenv for multiple python versions
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"

  export PATH="$HOME/.local/bin:$PATH"
  export EDITOR=nvim
fi

# ---------------------------
# Choose Plugin Manager:
# Set ZSH_PLUGIN_MANAGER to "ZI" for Zi or "ZINIT" for Zinit.
# ---------------------------
ZSH_PLUGIN_MANAGER="ZI"  # Change to "ZINIT" to use Zinit

if [[ "$ZSH_PLUGIN_MANAGER" == "ZI" ]]; then
  #############################
  # Initialize Zi Plugin Manager
  #############################
  typeset -A ZI
  ZI[BIN_DIR]="${HOME}/.zi/bin"
  source "${ZI[BIN_DIR]}/zi.zsh"

  # Enable Zi autocompletion
  autoload -Uz _zi
  (( ${+_comps} )) && _comps[zi]=_zi

  # Use PLUGIN_CMD to load plugins later
  PLUGIN_CMD="zi"

elif [[ "$ZSH_PLUGIN_MANAGER" == "ZINIT" ]]; then
  #############################
  # Initialize Zinit Plugin Manager
  #############################
  ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
  [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
  [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
  source "${ZINIT_HOME}/zinit.zsh"

  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit

  # Use PLUGIN_CMD to load plugins later
  PLUGIN_CMD="zinit"

else
  echo "Unknown ZSH_PLUGIN_MANAGER value: $ZSH_PLUGIN_MANAGER. Please set it to either 'ZI' or 'ZINIT'."
  return 1
fi

# ---------------------------
# System Proxy Settings (Uncomment if needed)
# export ALL_PROXY=127.0.0.1:7890
# export HTTP_PROXY=192.168.0.108:8899
# export HTTPS_PROXY=192.168.0.108:8899
# export SOCKS5_PROXY=192.168.0.108:9988
# ---------------------------

#############################
# Powerlevel10k Theme Setup
#############################
# Enable Powerlevel10k instant prompt for faster startup (keep near the top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Powerlevel10k with shallow clone for speed (depth=1)
$PLUGIN_CMD ice depth=1
$PLUGIN_CMD light romkatv/powerlevel10k

# Source user-specific Powerlevel10k configuration if it exists
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

#############################
# Common Zsh Plugin Configuration
#############################
# Standard plugins for a better shell experience
$PLUGIN_CMD light z-shell/H-S-MW
$PLUGIN_CMD light zsh-users/zsh-completions
$PLUGIN_CMD light zdharma/fast-syntax-highlighting
# Alternatively, you can use the official syntax highlighting:
# $PLUGIN_CMD light zsh-users/zsh-syntax-highlighting
$PLUGIN_CMD light zsh-users/zsh-autosuggestions

# exa is no longer maintained; using eza as a replacement
# $PLUGIN_CMD light DarrinTisdale/zsh-aliases-exa  # Deprecated exa version
# Check if 'eza' is installed; if so, load the z-shell/zsh-eza plugin.
if command -v eza >/dev/null 2>&1; then
  $PLUGIN_CMD light z-shell/zsh-eza
else
  echo "eza not found, skipping z-shell/zsh-eza plugin load."
fi

# Optional plugin (e.g., fzf-tab can be enabled if desired)
# $PLUGIN_CMD light Aloxaf/fzf-tab

#############################
# Oh My Zsh Snippets Loading
#############################
# Load useful snippets from Oh My Zsh repositories

# Load Git library snippet and then the Git plugin
$PLUGIN_CMD snippet OMZL::git.zsh
$PLUGIN_CMD snippet OMZP::git
$PLUGIN_CMD snippet OMZP::urltools

# Clear completions loaded so far to prevent conflicts
$PLUGIN_CMD cdclear -q

# Load additional common snippets
$PLUGIN_CMD snippet OMZL::clipboard.zsh         # Clipboard management
$PLUGIN_CMD snippet OMZL::completion.zsh          # Command completions
$PLUGIN_CMD snippet OMZL::history.zsh             # Command history
$PLUGIN_CMD snippet OMZL::key-bindings.zsh        # Key bindings
$PLUGIN_CMD snippet OMZL::theme-and-appearance.zsh  # Theme and appearance
$PLUGIN_CMD snippet OMZL::functions.zsh           # Common functions
$PLUGIN_CMD snippet OMZL::termsupport.zsh         # Terminal support

# Load Oh My Zsh plugin snippets
$PLUGIN_CMD snippet OMZP::dotenv
$PLUGIN_CMD snippet OMZP::rake
$PLUGIN_CMD snippet OMZP::rbenv
$PLUGIN_CMD snippet OMZP::ruby
$PLUGIN_CMD snippet OMZP::pip
# $PLUGIN_CMD snippet OMZP::sublime
$PLUGIN_CMD snippet OMZP::sudo
$PLUGIN_CMD snippet OMZP::rails
$PLUGIN_CMD snippet OMZP::textmate
$PLUGIN_CMD snippet OMZP::lighthouse
$PLUGIN_CMD snippet OMZP::gitignore
$PLUGIN_CMD snippet OMZP::colored-man-pages
$PLUGIN_CMD snippet OMZP::cp
$PLUGIN_CMD snippet OMZP::brew
$PLUGIN_CMD snippet OMZP::npm
# If needed, you can enable a tmux-related snippet:
# $PLUGIN_CMD snippet OMZP::tmux

# Custom aliases and tools
if [[ "$COMPANY_MACHINE" == "1" ]]; then
  alias sw='/app/epg/tools/bin/sw'
  export CONTAINER=podman
  # export CONTAINER=docker2podman
  if command -v rg >/dev/null 2>&1; then
    alias grep='rg'
  else
    echo "ripgrep (rg) not found, skipping grep alias."
  fi
fi

# ranger yazi
if command -v yazi >/dev/null 2>&1; then
  alias ra='yazi'
  alias yz='yazi'
else
  echo "yazi not found, skipping yazi aliases."
fi

# autojump
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd j)"
else
  echo "zoxide not found, skipping zoxide initialization."
fi

cheat() {
  curl "cheat.sh/$*"
}

# Check if 'thefuck' is installed; if so, initialize its alias.
if command -v thefuck >/dev/null 2>&1; then
  eval "$(thefuck --alias)"
else
  echo "thefuck command not found, skipping alias initialization."
  if [[ "$COMPANY_MACHINE" == "1" ]]; then
    echo "install thefuck."
    pip install thefuck
  fi
fi
