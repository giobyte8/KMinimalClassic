#!/bin/bash
#
# Installs the required dependencies for this theme:
# - Kwin YAML: https://github.com/zzag/kwin-effects-yet-another-magic-lamp
# - Papirus icon theme: https://github.com/PapirusDevelopmentTeam/papirus-icon-theme
#

function _yaml {
    printf "\nVerifying Kwin YAML\n"

    curr_dir="$(pwd)"
    target_dir="/opt/kwin_yaml"

    # Abort if $target_dir already exists
    if [ -d "$target_dir" ]; then
        echo "It seems that kwin YAML is already installed"
        return 0
    fi

    echo ">> Installing Kwin YAML"
    sudo mkdir -p "$target_dir"
    cd "$target_dir"

    # Install required dependencies
    echo "Installing Kwin YAML dependencies"
    sudo apt-get install -y cmake extra-cmake-modules kwin-dev libdbus-1-dev \
        libkf5config-dev libkf5configwidgets-dev libkf5coreaddons-dev \
        libkf5windowsystem-dev qtbase5-dev

    # Clone and install Kwin YAML
    echo "Cloning and compiling Kwin YAML"
    sudo git clone https://github.com/zzag/kwin-effects-yet-another-magic-lamp.git .
    sudo mkdir build && cd build
    sudo cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr
    sudo make
    sudo make install

    cd "$curr_dir"
}

function _papirus {
    printf "\nInstalling papirus icon theme\n"

    sudo add-apt-repository -y -u ppa:papirus/papirus
    sudo apt-get install -y papirus-icon-theme papirus-folders
}

_yaml
_papirus
