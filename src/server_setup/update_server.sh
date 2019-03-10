#!/usr/bin/env bash

echo "Updating the system..."
sudo apt update
sudo apt upgrade
sudo apt autoremove
sudo reboot
echo "System successfully updated!"