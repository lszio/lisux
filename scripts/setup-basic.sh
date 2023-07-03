#!/usr/bin/env bash

set -e
# set -v

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

declare -A packages
packages["yay"]="wget base-devel git"
packages["apt"]="wget curl git gcc build-essential libcurl4-openssl-dev automake zlib1g-dev"
packages["yum"]="wget curl git gcc autoconf libtool make automake libcurl-devel zlib-devel"
packages["dnf"]=${packages["dnf"]}
packages["guix"]="" # TODO
packages["pacman"]=${packages["yay"]}
packages["nix-env"]="" # TODO

[ `whoami` != "root" ] && SUDO="sudo"

if command-exists "yay"; then
    PM="yay"
elif command-exists "pacman";then
    PM="pacman"
elif command-exists "dnf";then
    PM="dnf"
elif command-exists "yum";then
    PM="yum"
elif command-exists "apt";then
    PM="apt"
elif command-exists "nix-env";then
    PM="nix-env"
elif command-exists "guix";then
    PM="guix"
fi

function install-basic() {
    echo "install basic"

    case $PM in
        "yay")
            yay -Syy && yay -S ${packages["yay"]} --needed --noconfirm;;
        "pacman")
            $SUDO pacman -Syy && $SUDO pacman -S ${packages["pacman"]} --needed --noconfirm;;
        "apt")
            $SUDO apt update && $SUDO apt install ${packages["apt"]} -y;;
        "yum")
            $SUDO yum install ${packages["yum"]} -y;;
        "dnf")
            $SUDO dnf install ${packages["dnf"]} -y;;
    esac

    install-roswell

    echo "Installation Finished"
}
function install-roswell() {
    if command-exists "ros";then
    	echo "ros already install" 
    elif [ "$PM" == "yay" ];then 
        yay -S roswell -y
    elif [ "$PM" == "pacman" ];then 
        $sudo pacman -S roswell -y
    else 
        get-roswell-source
        cd /tmp/roswell
        sh bootstrap
        ./configure
        make
        $SUDO make install
        cd $OLDPWD
        rm -rf /tmp/roswell
    fi

    if [ $SUDO];then
        ros setup
        ros install liszt21/aliya
    fi
}

function get-roswell-source() {
    echo "Clone roswell from gitee"
    git clone -b release https://gitee.com/mirrors/Roswell.git /tmp/roswell

    if [ $? -ne 0 ];then
        git clone -b release https://github.com/roswell/roswell.git /tmp/roswell
    fi
}

install-basic