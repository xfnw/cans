CMDLINE	?= loglevel=3 console=ttyS0,115200 ${APPEND}
MEMORY	?= 1G
EXTRA	?= -enable-kvm -nographic -nic user
ARCH	?= ${shell uname -m}
PFLAGS	?= boot --dhcp-no-bind -p 8926
TCVER	?= 16.1
TCARCH	?= x86
KERNEL	?= ${TCARCH}/distribution_files/vmlinuz
INITRD	?= ${TCARCH}/core.gz

run: check ${TCVER}/${TCARCH}/combi.gz ## start a QEMU virtual machine
	qemu-system-${ARCH} -m ${MEMORY} -kernel ${TCVER}/${KERNEL} -initrd ${TCVER}/${TCARCH}/combi.gz -append '${CMDLINE}' ${EXTRA}

pxe: check ${TCVER}/${TCARCH}/combi.gz ## boot a machine with pxe
	pixiecore ${PFLAGS} --cmdline '${CMDLINE}' ${TCVER}/${KERNEL} ${TCVER}/${TCARCH}/combi.gz

check: ${TCVER}/${KERNEL} ${TCVER}/${INITRD} distribution_files.md5.txt distribution_files.sha512.txt ## ensure file integrity
	md5sum --quiet --ignore-missing -c distribution_files.md5.txt
	sha512sum --quiet --ignore-missing -c distribution_files.sha512.txt

10.1/${TCARCH}/distribution_files/%:
	mkdir -p ${dir $@}
	wget http://tinycorelinux.net/10.x/${TCARCH}/archive/10.1/distribution_files/${notdir $@} -O $@

14.0/${TCARCH}/distribution_files/%:
	mkdir -p ${dir $@}
	wget http://tinycorelinux.net/14.x/${TCARCH}/archive/14.0/distribution_files/${notdir $@} -O $@

15.0/${TCARCH}/distribution_files/%:
	mkdir -p ${dir $@}
	wget http://tinycorelinux.net/15.x/${TCARCH}/archive/15.0/distribution_files/${notdir $@} -O $@

16.0/${TCARCH}/distribution_files/%:
	mkdir -p ${dir $@}
	wget http://tinycorelinux.net/16.x/${TCARCH}/archive/16.0/distribution_files/${notdir $@} -O $@

16.1/${TCARCH}/distribution_files/%:
	# warning: tc has yet to create the archive path for 16.1
	# this will fail verification if 16.2 is released
	mkdir -p ${dir $@}
	wget http://tinycorelinux.net/16.x/${TCARCH}/release/distribution_files/${notdir $@} -O $@

${TCVER}/${TCARCH}/core.gz: ${TCVER}/${TCARCH}/distribution_files/modules.gz ${TCVER}/${TCARCH}/distribution_files/rootfs.gz ## build 32 bit initrd

${TCVER}/${TCARCH}/corepure64.gz: ${TCVER}/${TCARCH}/distribution_files/modules64.gz ${TCVER}/${TCARCH}/distribution_files/rootfs64.gz ## build 64 bit initrd

overlay.gz: overlay/etc/inittab overlay/opt/bootlocal.sh ## build overlay initrd
	find overlay -printf "%P\0" | cpio --create --null --format newc -D overlay | gzip -9 > $@

${TCVER}/${TCARCH}/combi.gz: ${TCVER}/${INITRD} overlay.gz ## build concatenated initrd

%.gz:
	# QEMU lacks multiple initrd support, concatenate ourselves
	# https://bugs.launchpad.net/qemu/+bug/393569
	cat $^ > $@

dist: ## create distribution tarball
	tar czf tcci${VERSION}.tar.gz Makefile distribution_files.md5.txt distribution_files.sha512.txt overlay

clean: ## clean build artifacts (keeps tc)
	rm -f overlay.gz *.*/*/core64.gz *.*/*/combi.gz tcci*.tar.gz

help:
	@sed -n 's/^\([[:alnum:]_\/\.-]\+\):[^#]*\(## \(.*\)\)\{0,1\}/\1|\3/p' \
		${MAKEFILE_LIST} | column -tl2 -s '|'

