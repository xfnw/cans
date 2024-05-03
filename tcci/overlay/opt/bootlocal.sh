#!/bin/sh
# put other system startup commands here

# loosely based on archlinux's releng .automated_script.sh
# but without the bashisms

# default username if not specified in kernel cmdline
: ${USER:=tc}

read_cmdline() {
	for arg in $(cat /proc/cmdline); do
		case "$arg" in
			script=*)
				SCRIPT="$(printf %s "${arg#*=}")"
				;;
			user=*)
				USER="$(printf %s "${arg#*=}")"
				;;
			load=*)
				LOAD="$(printf %s "${arg#*=}")"
				;;
			console=*)
				CONSOLE="$(printf %s "${arg#*=}")"
				;;
			mirror=*|MIRROR=*)
				printf '%s\n' "${arg#*=}" > /opt/tcemirror
				;;
		esac
	done
}

wait_for_net() {
	printf 'waiting for network'
	for try in $(seq 30); do
		if [ "$(route -n | wc -l)" -gt 3 ]; then
			echo
			return 0
		fi
		printf .
		sleep 1
	done

	echo giving up
	return 2
}

run_load() {
	[ -n "$LOAD" ] && printf %s "$LOAD" | tr , ' ' |
		xargs sudo -u "$USER" tce-load -wil --
}

run_script() {
	sudo -u "$USER" mkdir -p /tmp/wd
	cd /tmp/wd

	[ -x script ] && return 0

	if printf %s "$SCRIPT" | grep -q '^\(http\|https\|ftp\)'; then
		wget -O script -- "$SCRIPT" || return 2
	else
		cp -- "$SCRIPT" script || return 2
	fi

	echo "starting $SCRIPT..."
	chmod +x script
	sudo -u "$USER" ./script
}

read_cmdline
wait_for_net
run_load
if [ -n "$SCRIPT" ]; then
	run_script || echo "failed to run $SCRIPT :("
else
	echo no script specified, starting getty instead
	/sbin/getty 38400 "${CONSOLE%,*}"
fi
poweroff -f

