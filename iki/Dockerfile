FROM alpine:latest

RUN apk add --no-cache git ikiwiki lighttpd python3 tcc tcc-libs-static musl-dev perl-db_file

RUN <<EOF
adduser -D -h /home/wiki wiki
# ikiwiki does not allow deviating from the "master" branch name
su wiki -c 'git config --global init.defaultBranch master'
ln -s /usr/bin/tcc /usr/bin/cc
mkdir /work /data
chown wiki:wiki /work /data
EOF

COPY startup.sh /usr/local/bin/
COPY lighttpd.conf /etc/lighttpd/
COPY auto.setup /etc/ikiwiki/
COPY 404.cgi /etc/ikiwiki/

EXPOSE 80
CMD ["/usr/local/bin/startup.sh"]
