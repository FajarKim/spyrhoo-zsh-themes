#!/bin/bash

# This script should be run via curl:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/FajarKim/spyrhoo-ohmyzsh-theme/master/tools/install.sh)"
# or via wget:
#   bash -c "$(wget -qO- https://raw.githubusercontent.com/FajarKim/spyrhoo-ohmyzsh-theme/master/tools/install.sh)"
# or via fetch:
#   bash -c "$(fetch -o - https://raw.githubusercontent.com/FajarKim/spyrhoo-ohmyzsh-theme/master/tools/install.sh)"

set -e

# Check OhMyZsh directory
if ! [ -d ~/.oh-my-zsh ]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh ~/.oh-my-zsh
fi

command_exists () {
        command -v "$@" >/dev/null 2>&1
}

prt_error () {
  printf '%sError: %s\n' "${RED}" "${@}${RESET}" >&2
}

setup_colors () {
  if [ -t 1 ]; then
        RESET=$(printf "\e[m")
        ITALIC=
        UNDERLINE=$(printf "\e[4m")
        RED=$(printf "\e[31m")
        GREEN=$(printf "\e[32m")
        YELLOW=$(printf "\e[33m")
        BLUE=$(printf "\e[34m")
        BOLD=$(printf "\e[1m")
  else
        RESET=""
        ITALIC=""
        UNDERLINE=""
        RED=""
        GREEN=""
        YELLOW=""
        BLUE=""
        BOLD=""
  fi
}

setup_theme () {
  command_exists git || {
    prt_error "git is not installed"
    exit 1
  }
  echo "${BLUE}Cloning Spyrhoo Theme${RESET}"
  git clone --depth=1 https://github.com/FajarKim/spyrhoo-ohmyzsh-theme ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spyrhoo || {
    prt_error "git clone of spyrhoo-ohmyzsh-theme repo failed!"
    exit 1
  }
}
setup_zshrc () {
  echo "${GREEN}Setting up themes to .zshrc ...${RESET}"
  if [ -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spyrhoo/templates ]; then
      cp -r ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spyrhoo/templates/zshrc.templates ~/.zshrc
  else
      zshrc="$(curl -fsSL https://raw.githubusercontent.com/FajarKim/spyrhoo-ohmyzsh-theme/master/templates/zshrc.templates)"
      cat <<EOF > ~/.zshrc
$zshrc
EOF
  fi
}

main () {
  setup_colors
  setup_theme
  setup_zshrc
}

main
