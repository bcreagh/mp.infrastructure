#!/usr/bin/env bash

PORTS=""
IMAGE_NAME="${@: -1}"
CONTAINER_NAME="${@: -1}"

while getopts ":p:" o; do
    case "${o}" in
        p)
            PORTS="$PORTS -p $OPTARG"
            ;;
    esac
done


docker run -d ${PORTS} --name ${CONTAINER_NAME} ${IMAGE_NAME}