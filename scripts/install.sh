#!/usr/bin/env bash

set -e
# set -v

declare -A packages
packages["yay"]="wget base-devel git"
packages["apt"]="wget curl git gcc build-essential libcurl4-openssl-dev automake zlib1g-dev"
packages["yum"]="wget curl git gcc autoconf libtool make automake libcurl-devel zlib-devel"
packages["guix"]=""
packages["pacman"]=${packages["yay"]}

[ `whoami` != "root" ] && SUDO="sudo"

echo "Variables:"
echo "  USE_MIRROR = ${USE_MIRROR:=false}"
echo "  NEED_GUIX = ${NEED_GUIX:=false}"
echo "  BASIC= ${BASIC:=false}"

function command-exists() {
    command -v "$@" >/dev/null 2>&1
}

function text-in-file() {
    # $1 text $2 file
    [ $1 ] && [ $2 ] && {
        [ ! -e $2 ] && {
            echo "File $2 not exist..."
            exit
        }
        grep "$1" < "$2" >/dev/null 2>&1
    }
}

function install-guix() {
    apt install guix || bash <(curl -sSL https://gitee.com/liszt21/lisux/raw/master/scripts/install-guix.sh)
    # cd /tmp
    # wget https://git.savannah.gnu.org/cgit/guix.git/plain/etc/guix-install.sh 
    # chmod +x guix-install.sh
    # ./guix-install.sh
}

function install-basic() {
    echo "install basic"

    case $PACKAGE_MANAGER in
        "yay")
            yay -Syy && yay -S ${packages["yay"]} --needed --noconfirm;;
        "pacman")
            $SUDO pacman -Syy && $SUDO pacman -S ${packages["pacman"]} --needed --noconfirm;;
        "apt")
            $SUDO apt update && $SUDO apt install ${packages["apt"]} -y;;
        "yum")
            $SUDO yum install ${packages["yum"]} -y;;
        "dnf")
            $SUDO yum install ${packages["yum"]} -y;;
    esac
}

command-exists pacman && PACKAGE_MANAGER="pacman"
command-exists apt && PACKAGE_MANAGER="apt"
command-exists yum && PACKAGE_MANAGER="yum"
command-exists dnf && PACKAGE_MANAGER="dnf"
command-exists yay && PACKAGE_MANAGER="yay"


[ $USE_MIRROR ] && bash <(curl -sSL https://gitee.com/liszt21/lisux/raw/master/scripts/mirror-helper.sh)
install-basic
[ $NEED_GUIX ] && ! command-exists guix && install-guix