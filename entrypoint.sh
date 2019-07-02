#!/bin/sh
IFACES_FILTER=""
OFFLOADING_IFACE=eth0
NOOFFLOADING=""
ETHTOOL_BIN=$(which ethtool)


# Disable iface offloading options
# This could negatively impact on system performance
if test -z $NOOFFLOADING ; then
  echo "Not implemented yet"
  $ETHTOOL_BIN -K $OFFLOADING_IFACE rx off
  $ETHTOOL_BIN -K $OFFLOADING_IFACE tx off
  $ETHTOOL_BIN -K $OFFLOADING_IFACE sg off
  $ETHTOOL_BIN -K $OFFLOADING_IFACE tso off
  $ETHTOOL_BIN -K $OFFLOADING_IFACE ufo off
  $ETHTOOL_BIN -K $OFFLOADING_IFACE gso off
  $ETHTOOL_BIN -K $OFFLOADING_IFACE gro off
  $ETHTOOL_BIN -K $OFFLOADING_IFACE lro off

fi

function iface_filter(){
  ip a|awk -F: '$1 ~ /^[a-z0-9]+/ && ($2 !~ /lo/ && $2 !~ /\s+docker0$/ ) { gsub("@docker0","",$2); gsub(/\s/,"",$2); a[NR]=$2 }END{for(i in a){output=output" -i "a[i]}; printf output"\n"}'
  
}

function kill_dumpcap(){
  DUMPCAP_PID=$(iface_filter)
  ps |grep -F "" |awk  ' $4 != "grep" {system("kill -9 "$1)}'

}

function check_ifaces(){
  ORIGINAL=$1
  CURRENT=$(iface_filter)
  IS_EQUAL=1
  if ["$ORIGINAL" != "$CURRENT"]; then
    IS_EQUAL=0
  fi
  return $IS_EQUAL
}

DUMPCAP_BIN=$(which dumpcap)
IFACES_FILTER=$(iface_filter)
echo "Initial \$IFACES_FILTER: $IFACES_FILTER"
while true; do
  $DUMPCAP_BIN -q -t -s $SNAPLENGHT $IFACES_FILTER -w - "($PCAP_FILTER) and not (dst host $SOCAT_HOST and dst port $SOCAT_PORT) adn not (src host $SOCAT_HOST and src port $SOCAT_PORT)"| \
  socat - openssl:"$SOCAT_HOST":"$SOCAT_PORT",verify=0,forever,retry=10,interval=5,ignoreeof
  sleep 1
done
