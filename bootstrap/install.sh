#!/bin/bash

# This runs as root on the server

chef_binary=chef-solo

# Are we on a vanilla system?
if ! hash "$chef_binary" 2>/dev/null; then
    apt-get update &&
    apt-get upgrade -y &&
    cd /tmp &&
    wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.10.0-1_amd64.deb
    dpkg -i chefdk_*.deb
fi &&

cd ~/chef &&
berks vendor &&
"$chef_binary" -c site_install.rb -j chef_config.json
