#!/bin/sh
set -e

if [ ! -d /wiki/.ikiwiki ]; then
	su wiki -c 'ikiwiki --setup /etc/ikiwiki/auto.setup'
	cp /etc/ikiwiki/404.cgi /wiki/www/
fi

su wiki -c 'ikiwiki --setup /wiki/wiki.setup'

echo starting lighttpd...
/usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf -D
