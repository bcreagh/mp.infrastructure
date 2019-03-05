#!/usr/bin/env bash

set -e

ip_address=""
is_virtual_box="false"

usage() { 
    echo "Usage: $0 -a <string> [-v] "; 
    exit 1; 
}

while getopts ":a:v:" o; do
    case "${o}" in
        a)
            ip_address=${OPTARG}
            ;;
        v)
            is_virtual_box="true"
            ;;
        *)
            usage
            ;;
    esac
done

if [ ip_address="" ] ; then
    usage
fi

apt update
apt upgrade

# if it is a virtualbox vm, configure the networking between host and vm
if [ is_virtual_box=="true" ] ; then
    cat ./netplan_example.yaml > /etc/netplan/50-cloud-init.yaml
    sed -i -e "s/<%GUEST_ADDRESS%>/${ip_address}/g" /etc/netplan/50-cloud-init.yaml
    netplan apply
fi

# Set customise the user profile
cd profile-setup
./linuxProfileSetup.sh
./applyChanges.sh

# install docker
apt-get update

apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io