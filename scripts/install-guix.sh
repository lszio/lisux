#!/usr/bin/env bash

set -e
# set -v

echo "Variables:"
echo "  GUIX_VERSION = ${GUIX_VERSION:=1.4.0}"
echo "  GNU_MIRROR = ${GNU_MIRROR:=https://mirror.sjtu.edu.cn/gnu/guix}"
echo "  ARCH_TYPE = ${ARCH_TYPE:=`uname -i`}"
echo "  GUIX_FILE = ${GUIX_FILE:=guix-binary-${GUIX_VERSION}.${ARCH_TYPE}-linux.tar.xz}"

cd /tmp
[ ! -f ${GUIX_FILE} ] && wget ${GNU_MIRROR}/${GUIX_FILE}

# VERIFY:
wget 'https://sv.gnu.org/people/viewgpg.php?user_id=15145' -qO - | gpg --import -
wget ${GNU_MIRROR}/${GUIX_FILE}.sig 
gpg --verify ${GUIX_FILE}.sig

# UNPACK
tar --warning=no-timestamp -xf ${GUIX_FILE} && mv var/guix /var/ && mv gnu / && rm ${GUIX_FILE}

mkdir -p ~root/.config/guix
ln -sf /var/guix/profiles/per-user/root/current-guix ~root/.config/guix/current

GUIX_PROFILE="`echo ~root`/.config/guix/current"
source $GUIX_PROFILE/etc/profile

groupadd --system guixbuild

for i in `seq -w 1 42`;
  do
    useradd -g guixbuild -G guixbuild           \
            -d /var/empty -s `which nologin`    \
            -c "Guix build user $i" --system    \
            guixbuilder$i;
  done

mkdir -p /usr/local/bin
cd /usr/local/bin
ln -s /var/guix/profiles/per-user/root/current-guix/bin/guix

mkdir -p /usr/local/share/info
cd /usr/local/share/info
for i in /var/guix/profiles/per-user/root/current-guix/share/info/*
do
  ln -s $i
done

guix archive --authorize < ~root/.config/guix/current/share/guix/ci.guix.info.pub

# pull
GUIX_PROFILE="`echo ~root`/.config/guix/current"
source $GUIX_PROFILE/etc/profile

guix-daemon --build-users-group=guixbuild --disable-chroot  --substitute-urls="https://mirror.sjtu.edu.cn/guix/ https://ci.guix.gnu.org" &
guix pull
guix package -u
guix gc
guix gc --optimize