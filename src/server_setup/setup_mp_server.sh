#!/usr/bin/env bash

ip_address=""

usage() { 
    echo "Usage: $0 -a <string>"; 
    exit 1; 
}

while getopts ":a:" o; do
    case "${o}" in
        a)
            ip_address=${OPTARG}
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

cat ./netplan_example.yaml > /etc/netplan/50-cloud-init.yaml
sed -i -e "s/<%GUEST_ADDRESS%>/${ip_address}/g" /etc/netplan/50-cloud-init.yaml
netplan apply

