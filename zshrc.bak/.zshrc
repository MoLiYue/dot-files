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

  # Add ~/bin to PATH if it exists
  if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
  fi

  export EDITOR=nvim
fi

#############################
# OS Specific Configuration
#############################
os=$(uname)

if [[ $os == "Darwin" ]]; then
  # macOS specific settings
  export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-18.0.2.jdk/Contents/Home"
  export PATH="/opt/homebrew/Cellar/node/21.7.1/bin:$PATH"
  export EDITOR="/opt/homebrew/bin/nvim"

elif [[ $os == "Linux" ]]; then
  # archlinux setup pyenv for multiple python versions
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

  if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  else
    print -P "%F{yellow}pyenv not found, skipping pyenv initialization.%f"
  fi

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

  if [[ -f "${ZI[BIN_DIR]}/zi.zsh" ]]; then
    source "${ZI[BIN_DIR]}/zi.zsh"
  else
    print -P "%F{red}Zi not found at ${ZI[BIN_DIR]}/zi.zsh%f"
    return 1
  fi

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
  print -P "%F{red}Unknown ZSH_PLUGIN_MANAGER value: $ZSH_PLUGIN_MANAGER. Please set it to either 'ZI' or 'ZINIT'.%f"
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
# Common Zsh Plugin Configuration
#############################
# Standard plugins for a better shell experience
$PLUGIN_CMD light z-shell/H-S-MW
$PLUGIN_CMD light zsh-users/zsh-completions
$PLUGIN_CMD light zdharma/fast-syntax-highlighting
$PLUGIN_CMD light zsh-users/zsh-autosuggestions

# exa is no longer maintained; using eza as a replacement
if command -v eza >/dev/null 2>&1; then
  $PLUGIN_CMD light z-shell/zsh-eza
else
  print -P "%F{yellow}eza not found, skipping z-shell/zsh-eza plugin load.%f"
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
$PLUGIN_CMD snippet OMZL::clipboard.zsh
$PLUGIN_CMD snippet OMZL::completion.zsh
$PLUGIN_CMD snippet OMZL::history.zsh
$PLUGIN_CMD snippet OMZL::key-bindings.zsh
$PLUGIN_CMD snippet OMZL::theme-and-appearance.zsh
$PLUGIN_CMD snippet OMZL::functions.zsh
$PLUGIN_CMD snippet OMZL::termsupport.zsh

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
# $PLUGIN_CMD snippet OMZP::tmux

#############################
# Custom aliases and tools
#############################
if [[ "$COMPANY_MACHINE" == "1" ]]; then
  alias sw='/app/epg/tools/bin/sw'
  export CONTAINER=podman

  if command -v rg >/dev/null 2>&1; then
    alias grep='rg'
  else
    print -P "%F{yellow}ripgrep (rg) not found, skipping grep alias.%f"
  fi
fi

# ranger yazi
if command -v yazi >/dev/null 2>&1; then
  alias ra='yazi'
  alias yz='yazi'
else
  print -P "%F{yellow}yazi not found, skipping yazi aliases.%f"
fi

# autojump / zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd j)"
else
  print -P "%F{yellow}zoxide not found, skipping zoxide initialization.%f"
fi

cheat() {
  curl "cheat.sh/$*"
}

# Check if 'thefuck' is installed; if so, initialize its alias.
if command -v thefuck >/dev/null 2>&1; then
  eval "$(thefuck --alias)"
else
  print -P "%F{yellow}thefuck command not found, skipping alias initialization.%f"
  if [[ "$COMPANY_MACHINE" == "1" ]]; then
    print -P "%F{yellow}install thefuck.%f"
    pip install thefuck
  fi
fi

#############################
# Welcome Output
#############################
# 保留你的输出
[[ -o interactive ]] && fastfetch

#############################
# Starship Prompt
#############################
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  print -P "%F{red}starship not found, prompt will fall back to default zsh prompt.%f"
fi
