#!/bin/bash

cd /home/container

export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

export MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
python3 /prompt.py --mode=echo
export MODIFIED_STARTUP=`echo $(python3 /prompt.py --mode=env)`
echo ":/home/container$ ${MODIFIED_STARTUP}"

eval ${MODIFIED_STARTUP}