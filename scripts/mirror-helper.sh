#!/usr/bin/env bash

set -e

declare -A mirrors
mirrors["base"]=${BASE_MIRROR:=http://mirror.sjtu.edu.cn}
mirrors["gnu"]=${GNU_MIRROR:=$BASE_MIRROR/gnu}
mirrors["arch"]=${ARCH_MIRROR:=$BASE_MIRROR/archlinux}
mirrors["ubuntu"]=${UBUNTU_MIRROR:=$BASE_MIRROR/ubuntu}
mirrors["manjaro"]=${MANJARO_MIRROR:=$BASE_MIRROR/manjaro}
mirrors["guix"]=${GUIX_MIRROR:=https://mirror.sjtu.edu.cn/guix}

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

function setup-mirrors() {
    echo "$PACKAGE_MANAGER"
    text-in-file "ubuntu" /etc/apt/sources.list && {
        echo "Setup ubuntu sources to ${mirrors['ubuntu']}"
        [ ! -f /etc/sources.list.lisux.bak ] && $SUDO cp /etc/apt/sources.list /etc/apt/sources.list.lisux.bak
        $SUDO sed -Ei "s@http(s)?://.*/ubuntu@${mirrors['ubuntu']}@g" /etc/apt/sources.list
    }
}

setup-mirrors
