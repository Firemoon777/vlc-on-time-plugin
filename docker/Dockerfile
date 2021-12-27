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

FROM debian:stretch-slim

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y \
        gcc-multilib \
        make \
        pkg-config \
        libvlc-dev:i386 libvlccore-dev:i386 \
        libvlc-dev:amd64 libvlccore-dev:amd64 \
        gcc-mingw-w64-i686 \
        gcc-mingw-w64-x86-64 \
        wget \
        p7zip \
    && wget ftp://ftp.videolan.org/pub/videolan/vlc/last/win32/vlc-*-win32.7z \
    && wget ftp://ftp.videolan.org/pub/videolan/vlc/last/win64/vlc-*-win64.7z \
    && 7zr x "*.7z" -o"/opt/*" */sdk \
    && rm *.7z \
    && rm -rf /var/lib/apt/lists/*

ADD build.sh .

ENTRYPOINT ["/bin/bash", "build.sh"]
