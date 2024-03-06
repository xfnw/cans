CMDLINE	?= loglevel=3 console=ttyS0,115200 ${APPEND}
MEMORY	?= 1G
EXTRA	?= -enable-kvm -nographic -nic user
ARCH	?= ${shell uname -m}
PFLAGS	?= boot --dhcp-no-bind -p 8926
TCVER	?= 10.1
KERNEL	?= ${TCVER}/distribution_files/vmlinuz
INITRD	?= ${TCVER}/distribution_files/core.gz

run: check ${TCVER}/combi.gz ## start a QEMU virtual machine
	qemu-system-${ARCH} -m ${MEMORY} -kernel ${KERNEL} -initrd ${TCVER}/combi.gz -append '${CMDLINE}' ${EXTRA}

pxe: check ${TCVER}/combi.gz ## boot a machine with pxe
	pixiecore ${PFLAGS} --cmdline '${CMDLINE}' ${KERNEL} ${TCVER}/combi.gz

check: ${KERNEL} ${INITRD} distribution_files.md5.txt distribution_files.sha512.txt ## ensure file integrity
	md5sum --quiet --ignore-missing -c distribution_files.md5.txt
	sha512sum --quiet --ignore-missing -c distribution_files.sha512.txt

10.1/distribution_files/%:
	mkdir -p 10.1/distribution_files
	wget http://tinycorelinux.net/10.x/x86/archive/10.1/distribution_files/${notdir $@} -O $@

14.0/distribution_files/%:
	mkdir -p 14.0/distribution_files
	wget http://tinycorelinux.net/14.x/x86/archive/14.0/distribution_files/${notdir $@} -O $@

15.0/distribution_files/%:
	# warning: tc has yet to create the archive path for 15.0
	# this will fail verification if 15.1 is released
	mkdir -p 15.0/distribution_files
	wget http://tinycorelinux.net/15.x/x86/release/distribution_files/${notdir $@} -O $@

${TCVER}/core64.gz: ${TCVER}/distribution_files/modules64.gz ${TCVER}/distribution_files/rootfs.gz ## build 64 bit initrd

overlay.gz: overlay/etc/inittab overlay/opt/bootlocal.sh ## build overlay initrd
	find overlay -printf "%P\0" | cpio --create --null --format newc -D overlay | gzip -9 > $@

${TCVER}/combi.gz: ${INITRD} overlay.gz ## build concatenated initrd

%.gz:
	# QEMU lacks multiple initrd support, concatenate ourselves
	# https://bugs.launchpad.net/qemu/+bug/393569
	cat $^ > $@

dist: ## create distribution tarball
	tar czf tcci${VERSION}.tar.gz Makefile distribution_files.md5.txt distribution_files.sha512.txt overlay

clean: ## clean build artifacts (keeps tc)
	rm -f overlay.gz *.*/core64.gz *.*/combi.gz tcci*.tar.gz

help:
	@sed -n 's/^\([[:alnum:]_\/\.-]\+\):[^#]*\(## \(.*\)\)\{0,1\}/\1|\3/p' \
		${MAKEFILE_LIST} | column -tl2 -s '|'

