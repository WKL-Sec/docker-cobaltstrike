#!/bin/bash

IPADDRESS="$(ip address | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d''/)"

cd /opt/cobaltstrike

# Check if we already downloaded CS teamserver or do we grab a fresh copy
FILE=/opt/cobaltstrike/cs-download-check

if [ -f "$FILE" ]; then
    /opt/cobaltstrike/teamserver $IPADDRESS ${COBALTSTRIKE_PASS} /opt/cobaltstrike/${COBALTSTRIKE_PROFILE} ${COBALTSTRIKE_EXP}
else
	touch /opt/cobaltstrike/cs-download-check
    token=`curl -s https://download.cobaltstrike.com/download -d "dlkey=${COBALTSTRIKE_KEY}" | grep 'href="/downloads/' | cut -d '/' -f3`
	curl -s https://download.cobaltstrike.com/downloads/${token}/latest46/cobaltstrike-dist.tgz -o /tmp/cobaltstrike.tgz
	tar zxf /tmp/cobaltstrike.tgz -C /opt
	echo ${COBALTSTRIKE_KEY} | /opt/cobaltstrike/update
	/opt/cobaltstrike/teamserver $IPADDRESS ${COBALTSTRIKE_PASS} /opt/cobaltstrike/${COBALTSTRIKE_PROFILE} ${COBALTSTRIKE_EXP}
fi
