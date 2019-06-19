#!/bin/sh -x
#
# Copyright (c) 2019 Martin Wilke (miwi@FreeBSD.org)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# $FreeBSD$
#


ISODIR="tmp/iso"

export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

cp -r iso-overlay/* ${ISODIR}/

#expermental chroot stuff
echo "Enable Services"
for i in bootmisc devd devfs hostname hostid kldxref modules network sysctl syscons
do
	chroot ${ISODIR} rc-update add $i boot
done

#experiment user
echo "Rename /usr/local to /usr/local2"
chroot ${ISODIR} mv /usr/local/ /usr/local2
chroot ${ISODIR} mkdir /usr/local
echo "Create User"
chroot ${ISODIR} pw groupadd penbsd
chroot ${ISODIR} pw useradd -n penbsd -m -s /usr/local2/bin/zsh -G wheel,video,operator -g penbsd  -d /usr/home/penbsd
chroot ${ISODIR} chown -R penbsd:penbsd /usr/home/penbsd

#Fix for KLD warning is newer than the linker.hints file
#chroot ${ISODIR} kldxref /boot/kernel
