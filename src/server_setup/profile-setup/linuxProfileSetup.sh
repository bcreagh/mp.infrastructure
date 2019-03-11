#!/usr/bin/env bash

# set aliases
if [ ! -f ~/.bash_aliases ]; then
    touch ~/.bash_aliases
fi

cat ./configFiles/aliases >> ~/.bash_aliases

# update .bashrc
if [ ! -f ~/.bashrc ]; then
    touch ~/.bashrc
fi

if [ ! -d ~/bin ]; then
    mkdir ~/bin
else
    sudo chown $USER ~/bin
    sudo chgrp $USER ~/bin
fi

cat ./configFiles/bashrc >> ~/.bashrc

# copy files to the local bin directory
cp -R ./bin/. ~/bin

# set permissions for the files
chmod -R u+x ~/bin
