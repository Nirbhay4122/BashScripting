#!/bin/bash

RUN_COMMAND() { $1 | sed "s/^/[INFO]  /"; }
PKG_INSTALL() { apt-get install $1 -y; }
pkgs=('curl' 'wget' 'python3' 'sed' 'grep')
# RUN_COMMAND "echo Installing basic dependencies."
for pkg in ${pkgs[@]}; do RUN_COMMAND "PKG_INSTALL ${pkg}"; done

