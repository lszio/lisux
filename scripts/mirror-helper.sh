#!/usr/bin/env bash

set -e

## 软件源列表
# 国内格式："软件源名称@软件源地址"
MIRROR_LIST=(
    "中国科学技术大学@mirrors.ustc.edu.cn"
    "阿里云@mirrors.aliyun.com"
    "上海交通大学@mirror.sjtu.edu.cn"
    "网易@mirrors.163.com"
    "搜狐@mirrors.sohu.com"
    "腾讯云@mirrors.tencent.com"
    "华为云@repo.huaweicloud.com"
    "北京大学@mirrors.pku.edu.cn"
    "浙江大学@mirrors.zju.edu.cn"
    "南京大学@mirrors.nju.edu.cn"
    "重庆大学@mirrors.cqu.edu.cn"
    "兰州大学@mirror.lzu.edu.cn"
    "清华大学@mirrors.tuna.tsinghua.edu.cn"
    "哈尔滨工业大学@mirrors.hit.edu.cn"
    "中国科学院软件研究所@mirror.iscas.ac.cn"
)
MIRROR_TYPE=${MIRROR_TYPE:-http}
MIRROR_INDEX=${MIRROR_INDEX:-1}

MIRROR_PICKED="$(eval echo \${MIRROR_LIST[$(($MIRROR_INDEX - 1))]} | awk -F '@' '{print$2}')"

declare -A mirrors
mirrors["base"]=${BASE_MIRROR:="$MIRROR_TYPE://$MIRROR_PICKED"}
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
    text-in-file "ubuntu" /etc/apt/sources.list && {
        echo "Setup ubuntu sources to ${mirrors['ubuntu']}"
        [ ! -f /etc/sources.list.lisux.bak ] && $SUDO cp /etc/apt/sources.list /etc/apt/sources.list.lisux.bak
        $SUDO sed -Ei "s@http(s)?://.*/ubuntu@${mirrors['ubuntu']}@g" /etc/apt/sources.list
    }
}

setup-mirrors
