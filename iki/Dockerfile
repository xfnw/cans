# ikiwiki is only packaged in edge/testing, change to latest if it
# makes its way to stable
FROM alpine:edge

RUN sed -i '/community$/{p;s/community$/testing/;}' /etc/apk/repositories && \
	apk add --no-cache git ikiwiki lighttpd

RUN sed -i '$s/.*/server.modules += ( "mod_cgi" )\n\
	cgi.assign = ( "ikiwiki.cgi" => "" )\n\
	&/' /etc/lighttpd/lighttpd.conf

EXPOSE 80
CMD /usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf -D
