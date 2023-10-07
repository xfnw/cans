# ikiwiki is only packaged in edge/testing, change to latest if it
# makes its way to stable
FROM alpine:edge

RUN sed -i '/community$/{p;s/community$/testing/;}' /etc/apk/repositories && \
	apk add --no-cache git ikiwiki lighttpd

EXPOSE 80

