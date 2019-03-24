FROM alpine

ADD entrypoint.sh /
RUN apk add tcpdump socat
RUN chmod 555 /entrypoint.sh
ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]
