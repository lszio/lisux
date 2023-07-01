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

    install-roswell

    echo "Installation Finished"
}

command-exists yay && PACKAGE_MANAGER="yay"
command-exists apt && PACKAGE_MANAGER="apt"
command-exists yum && PACKAGE_MANAGER="yum"
command-exists dnf && PACKAGE_MANAGER="dnf"
command-exists pacman && PACKAGE_MANAGER="pacman"

function install-roswell() {
    if [ command-exists ros ];then
    	echo "ros already install" 
    elif [ $PACKAGE_MANAGER -eq "yay" ];then 
        yay -S roswell -y
    elif [ $PACKAGE_MANAGER -eq "pacman" ];then 
        $sudo pacman -S roswell -y
    else 
        cd /tmp
        git clone -b release https://github.com/roswell/roswell.git
        cd roswell
        sh bootstrap
        ./configure
        make
        $sudo make install
    fi
}

install-basic