#!/bin/bash

cd /home/container

export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# CVE-2026-114938: the AVX-512 Base64 decode intrinsic in HotSpot writes out of bounds.
# JDK_JAVA_OPTIONS is read only by the JDK 9+ java launcher, so java8 (unaffected, and which
# refuses to start with this option) ignores it. Appended so a server's own options are kept.
# Remove once every bundled JDK is a fixed build.
export JDK_JAVA_OPTIONS="${JDK_JAVA_OPTIONS:+${JDK_JAVA_OPTIONS} }-XX:-UseBASE64Intrinsics"

[ ! -f server.properties ] && cat > server.properties << EOF
server-ip=0.0.0.0
server-port=${SERVER_PORT}
query.port=${SERVER_PORT}
EOF

export MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
python3 /prompt.py --mode=echo
export MODIFIED_STARTUP=`echo $(python3 /prompt.py --mode=env)`
echo ":/home/container$ ${MODIFIED_STARTUP}"

eval ${MODIFIED_STARTUP}
