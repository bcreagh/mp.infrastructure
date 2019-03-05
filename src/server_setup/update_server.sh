#!/usr/bin/env bash

echo "Updating the system..."
apt update
apt upgrade
apt autoremove
echo "System successfully updated!"