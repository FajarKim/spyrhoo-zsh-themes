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
        UNDERLINE=$(printf "\e[4m")
        RED=$(printf "\e[31m")
        GREEN=$(printf "\e[32m")
        YELLOW=$(printf "\e[33m")
        BLUE=$(printf "\e[34m")
        CYAN=$(printf "\e[36m")
        WHITE=$(printf "\e[37m")
        BOLD=$(printf "\e[1m")
  else
        RESET=""
        UNDERLINE=""
        RED=""
        GREEN=""
        YELLOW=""
        BLUE=""
        CYAN=""
        WHITE=""
        BOLD=""
  fi
}

setup_theme () {
  command_exists git || {
    prt_error "git is not installed"
    exit 1
  }
  echo "${BLUE}Cloning Spyrhoo Theme${RESET}"
  sleep 2
  git clone --depth=1 https://github.com/FajarKim/spyrhoo-ohmyzsh-theme ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spyrhoo || {
    prt_error "git clone of spyrhoo-ohmyzsh-theme repo failed!"
    exit 1
  }
}
setup_zshrc () {
  sleep 1
  echo "${GREEN}Setting up themes to .zshrc ...${RESET}"
  if [ -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spyrhoo/templates ]; then
      cp -r ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spyrhoo/templates/zshrc.templates ~/.zshrc
  else
      zshrc="$(curl -fsSL https://raw.githubusercontent.com/FajarKim/spyrhoo-ohmyzsh-theme/master/templates/zshrc.templates)"
      cat <<EOF > ~/.zshrc
$zshrc
EOF
  fi
  sleep 2
  echo "
${BOLD}${RED}          ╔═══╦═══╦╗  ╔╦═══╦╗ ╔╦═══╦═══╗
          ║╔═╗║╔═╗║╚╗╔╝║╔═╗║║ ║║╔═╗║╔═╗║
${GREEN}          ║╚══╣╚═╝╠╗╚╝╔╣╚═╝║╚═╝║║ ║║║ ║║
          ╚══╗║╔══╝╚╗╔╝║╔╗╔╣╔═╗║║ ║║║ ║║
${RED}          ║╚═╝║║    ║║ ║║║╚╣║ ║║╚═╝║╚═╝║
          ╚═══╩╝    ╚╝ ╚╝╚═╩╝ ╚╩═══╩═══╝${RESET}"
  echo "${BOLD}${RED}[${GREEN}+${RED}]${BLUE} Author : ${WHITE}Fajar Kim
${RED}[${GREEN}+${RED}]${BLUE} Version: ${WHITE}1.10

• ${YELLOW}Contact Person
${BLUE}[${RED}+${BLUE}]${WHITE} Facebook : ${UNDERLINE}${CYAN}https://bit.ly/fb-fajarkim${RESET}${BOLD}
${BLUE}[${RED}+${BLUE}]${WHITE} WhatsApp : ${UNDERLINE}${CYAN}https://bit.ly/wa-fajarkim${RESET}${BOLD}
${BLUE}[${RED}+${BLUE}]${WHITE} Telegram : ${UNDERLINE}${CYAN}https://t.me/FajarThea${RESET}${BOLD}
${BLUE}[${RED}+${BLUE}]${WHITE} Instagram: ${UNDERLINE}${CYAN}https://instagram.com/fajarkim_${RESET}${BOLD}
${BLUE}[${RED}+${BLUE}]${WHITE} E-Mail   : ${CYAN}fajarrkim@gmail.com${RESET}"
  sleep 1
  bash -c "env zsh"
}

main () {
  setup_colors
  setup_theme
  setup_zshrc
}

main
