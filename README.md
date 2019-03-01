# TOPO Forwarder 
<img width="25%" height="25%" src="http://www.quickmeme.com/img/4e/4e3494d68eca8e0aa5b00595b2091a973416732e4e0290b5c94efdf437a5c03e.jpg"/>

TOPO is a tcpdump forwarder for kubernetes designed to redirect traffic off all nodes to an IDS, Molloch server or something similar. 

This is the very first test and it has not been tested on production environments.

First design has been tested in GCP, but it should work in any kubernetes cluster.

## Usage
## Receiver node:
```bash  
  openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout cert.key -out cert.pem
  socat openssl-listen:8080,cert=/cert.pem,key=/cert.key,keepalive,reuseaddr,fork,verify=0 SYSTEM:'tcpdump -r -  -w tcpdump_$(date +%s).pcap'
```
## Deploy DaemonSet
We use Daemon set for __topo__ because we need every time a pod has been updated.
First of all modify topo-ds.yaml with your SOCAT server IP's and SOCAT server PORT you are going to use. 
Then, create the DS. 
```bash
  kubectl apply -f topo-ds.yaml
```

## Concerns
* Performance
* Resilience
 * Client should detect when TCP connection against socat server has been broken/closed and restart the DS. Now I think it is detected when socat tries to sent data, so some data can be lost in non too busy scenarios.
* Security! used pod runs in privileged mode! It is needed to add readonly filesystem and other security measures.
 * Least prvileges possible
 * SecurityContext, seccomp
 * Disable all non needed Capabilities
 * tcpdump command with least privileges possible
 * CA certificate for clients
 * Receiver security: iptables
 

## TODOs.

[ ] Enhance Docker image. Detect and shutdown pod if tls tunnel is brocken. 

[ ] Create Network policy

[ ] Clean yaml. For sure there are no needed permissions 

[ ] Test in AZURE

[ ] Test in AWS

[ ] Performance test and enhancements. 

[ ] Minimize the overhead

[ ] Solution for POD's localhost traffic sniffing

[ ] Automate receiver host deployment

 
