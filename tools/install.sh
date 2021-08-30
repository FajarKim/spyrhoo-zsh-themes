#!/bin/sh

# This script should be run via curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/FajarKim/spyrhoo-ohmyzsh-theme/master/tools/install.sh)"
# or via wget:
#   sh -c "$(wget -qO- https://raw.githubusercontent.com/FajarKim/spyrhoo-ohmyzsh-theme/master/tools/install.sh)"
# or via fetch:
#   sh -c "$(fetch -o - https://raw.githubusercontent.com/FajarKim/spyrhoo-ohmyzsh-theme/master/tools/install.sh)"

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

  git clone --depth=1 https://github.com/FajarKim/spyrhoo-ohmyzsh-theme ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spyrhoo || {
    prt_error "git clone of spyrhoo-ohmyzsh-theme repo failed!"
    exit 1
  }

setup_zshrc () {
  if [ -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spyrhoo/templates ]; then
      cp -r ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spyrhoo/templates/zshrc.templates ~/.zshrc
  else
      zshrc="https://raw.githubusercontent.com/FajarKim/spyrhoo-ohmyzsh-theme/master/templates/zshrc.templates"
      cat <<EOF > ~/.zshrc
$zshrc
EOF
  fi

  case "$PREFIX" in
  *com.termux*) termux=true; zsh=zsh;;
  *) termux=false;;
  esac

  printf '%sDo you want to change your default shell to zsh? [Y/n]%s ' \
    "$YELLOW" "$RESET"
  read -r opt
  case $opt in
    y*|Y*|"") echo "Changing the shell..." ;;
    n*|N*) echo "Shell change skipped."; return ;;
    *) echo "Invalid choice. Shell change skipped."; return ;;
  esac

  if [ "$termux" != true ]; then
    # Test for the right location of the "shells" file
    if [ -f /etc/shells ]; then
      shells_file=/etc/shells
    elif [ -f /usr/share/defaults/etc/shells ]; then # Solus OS
      shells_file=/usr/share/defaults/etc/shells
    else
      ptr_error "could not find /etc/shells file. Change your default shell manually."
      return
    fi

    # Get the path to the right zsh binary
    # 1. Use the most preceding one based on $PATH, then check that it's in the shells file
    # 2. If that fails, get a zsh path from the shells file, then check it actually exists
    if ! zsh=$(command -v zsh) || ! grep -qx "$zsh" "$shells_file"; then
      if ! zsh=$(grep '^/.*/zsh$' "$shells_file" | tail -1) || [ ! -f "$zsh" ]; then
        ptr_error "no zsh binary found or not present in '$shells_file'"
        ptr_error "change your default shell manually."
        return
      fi
    fi
  fi
}

main () {
  setup_colors
  setup_theme
  setup_zshrc
}

main
