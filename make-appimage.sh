#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q drum-machine | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/io.github.revisto.drum-machine.svg
export DESKTOP=/usr/share/applications/io.github.revisto.drum-machine.desktop
export DEPLOY_SYS_PYTHON=1
export DEPLOY_SDL=1
export DEPLOY_GTK=1
export GTK_DIR=gtk-4.0
export ANYLINUX_LIB=1
export DEPLOY_LOCALE=1
export STARTUPWMCLASS=io.github.revisto.drum-machine # Default to Wayland's wmclass. For X11, GTK_CLASS_FIX will force the wmclass to be the Wayland one.
export GTK_CLASS_FIX=1

# Deploy dependencies
quick-sharun /usr/bin/drum-machine \
             /usr/lib/libgirepository* \
             /usr/bin/ffmpeg

# Patch Drum Machine to use AppImage's directory
sed -i '/^pkgdatadir/c\pkgdatadir = os.getenv("SHARUN_DIR", "/usr") + "/share/drum-machine"' ./AppDir/bin/drum-machine
sed -i '/^localedir/c\localedir = os.getenv("SHARUN_DIR", "/usr") + "/share/locale"' ./AppDir/bin/drum-machine

# Turn AppDir into AppImage
quick-sharun --make-appimage
