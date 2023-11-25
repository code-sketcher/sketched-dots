#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install -y nala
sudo nala install -y xorg cmake make gcc 
sudo nala install -y lua5.2 liblua5.3-dev lua-busted lua-discount lua-ldoc lua-lgi lua5.3 
sudo nala install -y asciidoctor debhelper-compat  imagemagick libcairo2-dev libdbus-1-dev libgdk-pixbuf2.0-dev libglib2.0-dev libpango1.0-dev libstartup-notification0-dev libx11-xcb-dev libxcb-cursor-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-randr0-dev libxcb-shape0-dev libxcb-util0-dev libxcb-xinerama0-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-xtest0-dev libxdg-basedir-dev libxkbcommon-dev libxkbcommon-x11-dev x11proto-core-dev xmlto zsh  build-essential dbus-x11 gir1.2-gtk-3.0 libxcb-icccm4-dev libxcb-util0-dev libxcb1-dev x11-apps x11-utils x11-xserver-utils xfonts-base xterm xvfb libxcb-xfixes0-dev
git clone https://github.com/awesomeWM/awesome.git ~/awesome && \ 
  cd ~/awesome && \ 
  mkdir build && \ 
  cd build && \
  cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DSYSCONFDIR=/etc && \
  make -j4 && \
  make package \
  sudo dpkg -i *.deb
