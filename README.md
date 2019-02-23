socat tcp4-listen:8080,keepalive,reuseaddr,fork SYSTEM:'tee -a output$(date +%s).pcap'
socat tcp4-listen:8080,keepalive,reuseaddr,fork SYSTEM:'tcpdump output$(date +%s).pcap'

openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout cert.key -out cert.pem

socat openssl-listen:8080,cert=/cert.pem,key=/cert.key,keepalive,reuseaddr,fork,verify=0 SYSTEM:'tcpdump -r -  -w tcpdump_$(date +%s).pcap'
