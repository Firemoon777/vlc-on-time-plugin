#!/bin/bash

# Copyright (C) 2019 Aleksey Koltakov
#
# Authors: Aleksey Koltakov <aleksey.koltakov@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 2.1 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.

# Script to build a vlc plugin for Linux and Windows, for both 32-bit and 64-bit versions.
OS=${1:-ALL}
BITNESS=${2:-ALL}
shopt -s nocasematch

build_for_linux() {
    local BITNESS=$1

    if [[ "$BITNESS" == "ALL" ]]; then
        build_for_linux 32
        build_for_linux 64
        return
    fi

    echo -e "\nBuild a plugin for Linux $BITNESS-bit..."
    cd /plugin
    make clean
    make CC="cc -m$BITNESS"
    cp *.so build/linux/$BITNESS/
}

build_for_windows() {
    local BITNESS=$1
    declare -A PREFIX; PREFIX=( [32]="i686" [64]="x86_64" )

    if [[ "$BITNESS" == "ALL" ]]; then
        build_for_windows 32
        build_for_windows 64
        return
    fi

    echo -e "\nBuild a plugin for Windows $BITNESS-bit..."
    cd /opt/vlc-*-win$BITNESS/vlc-*/sdk/
    sed -i "s|^prefix=.*|prefix=${PWD}|g" lib/pkgconfig/*.pc
    export PKG_CONFIG_PATH="${PWD}/lib/pkgconfig:$PKG_CONFIG_PATH"

    cd /plugin
    make clean
    make CC=${PREFIX[$BITNESS]}-w64-mingw32-gcc LD=${PREFIX[$BITNESS]}-w64-mingw32-ld OS=Windows_NT
    cp *.dll build/win/$BITNESS/
}


if [[ ! "$OS" =~ ^(LINUX|WINDOWS|ALL)$ ]]; then
    echo "ERROR: Unsupported OS '$OS', please specify one of the following values: 'linux', 'windows' or 'all'"
    exit 1
fi

if [[ ! "$BITNESS" =~ ^(32|64|ALL)$ ]]; then
    echo "ERROR: Unsupported bitness '$BITNESS', please specify one of the following values: '32', '64' or 'all'"
    exit 1
fi

case $OS in
LINUX)
    build_for_linux $BITNESS
    ;;
WINDOWS)
    build_for_windows $BITNESS
    ;;
ALL)
    build_for_linux $BITNESS
    build_for_windows $BITNESS
    ;;
esac
