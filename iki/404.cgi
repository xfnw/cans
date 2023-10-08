#!/bin/sh
# https://ikiwiki.info/bugs/404_plugin_and_lighttpd/

export REDIRECT_URL="$SERVER_NAME$REQUEST_URI"

exec /wiki/www/ikiwiki.cgi "$@"
