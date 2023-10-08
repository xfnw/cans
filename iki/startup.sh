#!/bin/sh
set -e

[ -d /wiki/wiki.git ] || su wiki -c 'ikiwiki --setup /etc/ikiwiki/auto.setup'

/usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf -D
