CMDLINE	?= loglevel=3 console=ttyS0,115200 ${APPEND}
EXTRA	?= -enable-kvm -nographic -nic user
ARCH	?= ${shell uname -m}
KERNEL	?= distribution_files/vmlinuz
INITRD	?= distribution_files/core.gz

run: check combi.gz ## start a QEMU virtual machine
	qemu-system-${ARCH} -kernel ${KERNEL} -initrd combi.gz -append "${CMDLINE}" ${EXTRA}

check: ${KERNEL} ${INITRD} distribution_files.md5.txt distribution_files.sha512.txt ## ensure file integrity
	md5sum -c distribution_files.md5.txt
	sha512sum -c distribution_files.sha512.txt

distribution_files/%:
	mkdir -p distribution_files
	wget http://tinycorelinux.net/10.x/x86/archive/10.1/$@ -O $@

overlay.gz: overlay/etc/inittab overlay/opt/bootlocal.sh ## build overlay initrd
	find overlay -printf "%P\0" | cpio --create --null --format newc -D overlay | gzip > $@

combi.gz: ${INITRD} overlay.gz ## build concatenated initrd
	# QEMU lacks multiple initrd support, concatenate ourselves
	# https://bugs.launchpad.net/qemu/+bug/393569
	cat $^ > $@

dist: ## create distribution tarball
	tar czf tcci${VERSION}.tar.gz Makefile distribution_files.md5.txt distribution_files.sha512.txt overlay Makefile

clean: ## clean build artifacts (keeps tc)
	rm -f overlay.gz combi.gz tcci*.tar.gz

help:
	@sed -n 's/^\([[:alnum:]_\/\.-]\+\):[^#]*\(## \(.*\)\)\{0,1\}/\1|\3/p' \
		${MAKEFILE_LIST} | column -tl2 -s '|'

