#!/usr/bin/env bash

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