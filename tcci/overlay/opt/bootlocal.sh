#!/bin/sh
# put other system startup commands here

# loosely based on archlinux's releng .automated_script.sh
# but without the bashisms

# default username if not specified in kernel cmdline
user=tc

read_cmdline() {
	for arg in $(cat /proc/cmdline); do
		case "$arg" in
			script=*)
				script="$(printf %s "${arg#*=}")"
				;;
			user=*)
				user="$(printf %s "${arg#*=}")"
				;;
			load=*)
				load="$(printf %s "${arg#*=}")"
				;;
		esac
	done
}

wait_for_net() {
	echo waiting for network...
	for try in $(seq 30); do
		[[ "$(route -n | wc -l)" -gt 3 ]] && return 0
		sleep 1
	done

	return 2
}

run_load() {
	[[ -n "$load" ]] && printf %s "$load" | tr , ' ' |
		xargs sudo -u "${user}" tce-load -wil --
}

run_script() {
	sudo -u "${user}" mkdir -p /tmp/wd
	cd /tmp/wd

	script="$@"
	[[ -z "$script" || -x script ]] && return 0

	if printf %s "$script" | grep -q '^\(http\|https\|ftp\)'; then
		wget -O script -- "$script" || return 2
	else
		cp -- "$script" script || return 2
	fi

	echo "starting $script..."
	chmod +x script
	sudo -u "${user}" ./script
}

read_cmdline
wait_for_net
run_load
run_script "$script" || echo "failed to get $script"
[[ -n "$script" ]] && poweroff

