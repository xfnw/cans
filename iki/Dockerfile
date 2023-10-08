# ikiwiki is only packaged in edge/testing, change to latest if it
# makes its way to stable
FROM alpine:edge

RUN sed -i '/community$/{p;s/community$/testing/;}' /etc/apk/repositories && \
	apk add --no-cache git ikiwiki lighttpd python3 tcc musl-dev perl-db_file

# ikiwiki does not allow deviating from the "master" branch name
RUN adduser -D -h /wiki wiki &&\
	su wiki -c 'git config --global init.defaultBranch master' &&\
	ln -s /usr/bin/tcc /usr/bin/cc

COPY startup.sh /usr/local/bin/
COPY lighttpd.conf /etc/lighttpd/
COPY auto.setup /etc/ikiwiki/

EXPOSE 80
CMD /usr/local/bin/startup.sh
