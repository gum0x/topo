#!/bin/sh

# Disable iface offloading options
# This could negatively impact on system performance
if test -z $NOOFFLOADING ; then
  echo "Not implemented yet"
  ##/sbin/ethtool -K em2 rx off
  ##/sbin/ethtool -K em2 tx off
  ##/sbin/ethtool -K em2 sg off
  ##/sbin/ethtool -K em2 tso off
  ##/sbin/ethtool -K em2 ufo off
  ##/sbin/ethtool -K em2 gso off
  ##/sbin/ethtool -K em2 gro off
  ##/sbin/ethtool -K em2 lro off

fi

while true; do
	echo "Starting tcpdump and tunnel in $(hostname)"
	echo openssl:"$SOCAT_HOST":"$SOCAT_PORT":verify=0,ignoreeof && \
	/usr/sbin/tcpdump -s $SNAPLENGHT -i ${IFACE} -w - "($PCAP_FILTER) and not (dst host $SOCAT_HOST and dst port $SOCAT_PORT)"| \
       	socat - openssl:"$SOCAT_HOST":"$SOCAT_PORT",verify=0,forever,retry=10,interval=5,ignoreeof
	echo "Tunnel stopped in $(hostname)"
	sleep 1
done
