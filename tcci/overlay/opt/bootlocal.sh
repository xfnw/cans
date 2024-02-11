#!/bin/sh
# put other system startup commands here

# based on archlinux's releng .automated_script.sh
# but without the bashisms
get_script() {
	for arg in $(cat /proc/cmdline); do
		case "$arg" in
			script=*)
				printf %s "${arg#*=}"
				return 0 ;;
		esac
	done
}

rwget() {
	for try in $(seq 10); do
		wget "$@" && return 0
		sleep 1
	done

	return 2
}

run_script() {
	mkdir -p /tmp/wd
	cd /tmp/wd

	script="$@"
	[[ -z "$script" || -x script ]] && return 0

	if printf %s "$script" | grep -q '^\(http\|https\|ftp\)'; then
		rwget -O script -- "$script" || return 2
	else
		cp -- "$script" script || return 2
	fi

	echo "starting $script..."
	chmod +x script
	./script
}

script="$(get_script)"
run_script "$script" || echo "failed to get $script"
[[ -n "$script" ]] && poweroff

