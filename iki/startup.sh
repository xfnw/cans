#!/bin/sh
set -e

if [ ! -e /data/wiki.setup ]; then
	su wiki -c 'ikiwiki --setup /etc/ikiwiki/auto.setup'
fi

if [ ! -e /data/state ]; then
	su wiki -c 'git clone /data/wiki.git /data/state'
fi

su wiki -c 'install -Dt /work/www /etc/ikiwiki/404.cgi'
su wiki -c 'ikiwiki --setup /data/wiki.setup'

echo starting lighttpd...
/usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf -D
