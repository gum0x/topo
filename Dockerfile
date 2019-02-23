FROM alpine

ADD entrypoint.sh /
ENV IFACE any
ENV PCAP_FILTER port 80
ENV SOCAT_HOST 172.17.0.3
ENV SOCAT_PORT 8080
#USER root
RUN apk add tcpdump socat
RUN chmod 555 /entrypoint.sh
ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]
