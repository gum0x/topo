#!/bin/sh
while true; do
	echo "Starting tcpdump and tunnel in $(hostname)"
	echo openssl:"$SOCAT_HOST":"$SOCAT_PORT":verify=0,ignoreeof && \
	/usr/sbin/tcpdump -i ${IFACE} -w - "($PCAP_FILTER) and not (dst host $SOCAT_HOST and dst port $SOCAT_PORT)"| \
       	socat - openssl:"$SOCAT_HOST":"$SOCAT_PORT",verify=0,ignoreeof
	echo "Tunnel stopped in $(hostname)"
	sleep 1
done
