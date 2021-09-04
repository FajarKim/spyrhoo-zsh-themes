#!/usr/bin/env bash

# Use colors, but only if connected to a terminal, and that terminal
# supports them.

path="$PWD"
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  NORMAL=""
fi

printf "${BLUE}%s${NORMAL}\n" "Updating Theme Spyrhoo"
cd "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spyrhoo"
if git pull --rebase --stat origin master
then
   echo "
${BOLD}${RED}          ╔═══╦═══╦╗  ╔╦═══╦╗ ╔╦═══╦═══╗
          ║╔═╗║╔═╗║╚╗╔╝║╔═╗║║ ║║╔═╗║╔═╗║
${GREEN}          ║╚══╣╚═╝╠╗╚╝╔╣╚═╝║╚═╝║║ ║║║ ║║
          ╚══╗║╔══╝╚╗╔╝║╔╗╔╣╔═╗║║ ║║║ ║║
${RED}          ║╚═╝║║    ║║ ║║║╚╣║ ║║╚═╝║╚═╝║
          ╚═══╩╝    ╚╝ ╚╝╚═╩╝ ╚╩═══╩═══╝${NORMAL}"
   echo "${BOLD}${YELLOW}Okay, ${BLUE}Spyrhoo has been updates!${NORMAL}"
else
   echo "${BOLD}${RED}Oh no, there was an error updating...${NORMAL}"
fi
cd "$path"
