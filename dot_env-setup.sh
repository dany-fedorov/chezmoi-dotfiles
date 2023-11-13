#!/bin/sh

# This file is to be sourced (by ~/.xinitrc or ~/.xsession)

# dir with custom scripts
mkdir -p "$HOME/bin"
PATH="$PATH:$HOME/bin"
PATH="$PATH:$HOME/.local/bin"

# style for highlight command
export DF_HIGHLIGHT_STYLE=denim

# determine this machine
export DF_THIS_MACHINE
export DF_CONFIGS
export DF_LOCAL_CONFIGS
if [ "$(whoami)" = 'df' ] && [ "$(hostname)" = 'dfpc' ]; then
  DF_THIS_MACHINE=home2
  DF_CONFIGS=~/df-configs
  # DF_LOCAL_CONFIGS=$DF_CONFIGS/local
  DF_LOCAL_CONFIGS=~/sensitive-configs
elif [ "$(whoami)" = 'df' ] && [ "$(hostname)" = 'dfpc2' ]; then
  DF_THIS_MACHINE=home3
  DF_CONFIGS=~/df-configs
elif [ "$(whoami)" = 'df' ] && [ "$(hostname)" = 'dfd' ]; then
  DF_THIS_MACHINE=work4
  DF_CONFIGS=~/df-configs
elif [ "$(whoami)" = 'dfedorov' ]; then
  DF_THIS_MACHINE=work2
  DF_CONFIGS=~/df-configs
  DF_LOCAL_CONFIGS=~/sensitive-configs
# elif [ "$(whoami)" = 'ubuntu' ]; then
#   DF_THIS_MACHINE=work2
#   DF_CONFIGS=~/df-configs
#   DF_LOCAL_CONFIGS=~/sensitive-configs
fi
readonly DF_CONFIGS
readonly DF_LOCAL_CONFIGS
readonly DF_THIS_MACHINE

export SUDO_EDITOR=gvim
export EDITOR=gvim
# export BROWSER=firefox
export BROWSER=google-chrome
export TERMINAL=gnome-terminal
SHELL="$(command -v bash)"
export SHELL

# if [ $DF_THIS_MACHINE = 'work' ]; then
#   xrandr --output HDMI1 --auto --output VGA1 --auto --left-of HDMI1
# fi

# Added by Toolbox App
export PATH="$PATH:/home/df/.local/share/JetBrains/Toolbox/scripts"

#if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
#  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
#fi

readonly DF_DROPBOX_PATH="$HOME/Dropbox"
export DF_DROPBOX_PATH

export KEEP_BUILD_UTILS_HOME="/home/df/wd/geniusee/keep/keep-build-image"

if [[ "$OSTYPE" = "darwin"* && $(whoami) = 'danylofedorov' ]]; then
  export CLICOLOR=1 
fi
