#!/usr/bin/env bash

set -e

ip_address=""
is_virtual_box="false"

usage() { 
    echo "Usage: $0 -a <string> [-v] "; 
    exit 1; 
}

while getopts ":a:v" o; do
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

if [ -z "$ip_address" ] ; then
    usage
fi

# if it is a virtualbox vm, configure the networking between host and vm
if [ is_virtual_box=="true" ] ; then
    echo "This is a vm running in VirtualBox"
    echo "Configuring Host-Only Adapter network..."
    cat ./netplan_example.yaml > /etc/netplan/50-cloud-init.yaml
    sed -i -e "s@<%GUEST_ADDRESS%>@${ip_address}@g" /etc/netplan/50-cloud-init.yaml
    netplan apply
    echo "Network configured!"
fi


# Set customise the user profile
echo "Setting up the user profile..."
cd profile-setup
./linuxProfileSetup.sh
./applyChanges.sh
echo "User profile successfully set up!"

# install docker
echo "Adding repository for docker installation..."
apt-get update

apt-get -y install \
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
echo "Repository added!"

echo "Installing docker..."
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io
echo "Docker successfully installed!"

if [ ! -d ~/mega-project ]; then
    mkdir ~/mega-project
fi

echo "Installing git repositories..."
cd ~/mega-project
git clone https://github.com/bcreagh/mp.proof-of-concept.git
git clone https://github.com/bcreagh/mp.frontend.git
echo "Git repositories successfully installed"