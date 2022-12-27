#!/bin/bash

docker build --network=host -t yubihsm .; ec=$?
if [ $ec -ne 0 ]; then
    echo "build failed"
    exit 1
fi

vp_hsm="1050:0030"  ## vendor:product of yubihsm

export DEVICE_LIST=$(ls -1 /dev/bus/usb/$(lsusb -d "$vp_hsm" | awk '{ print $2 "/" $4 }' | tr -d ":"))

arg_device_list=""
for device in $DEVICE_LIST; do
    arg_device_list="$arg_device_list --device $device"
done

if [ "$arg_device_list" == "" ]; then
    echo "device list is empty, is your hsm connected?"
    exit 2
fi

docker rm -f yubihsm-connector
docker run --name yubihsm-connector -d --restart always -p 3263:3263 $arg_device_list yubihsm
