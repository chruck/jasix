# Makefile for 1-mkfs

# manipulation of the target

TARGET := .complete
TARGET_DEV := /dev/sda
TARGET_DIR := /target
TGT_USR := ${TARGET_DIR}/usr
TGT_SRC := ${TGT_USR}/src

#all: ${TARGET}
all: ${TGT_SRC}

#.PHONY: ${TARGET_DIR}
${TARGET_DIR}:
	sudo mkdir -p $@

MOUNTED := ${TARGET_DIR}/.mounted
${MOUNTED}: ${TARGET_DIR}
	sudo dd if=/dev/zero of=${TARGET_DEV} bs=1 count=1k
	sudo mke2fs -L jasix ${TARGET_DEV}
	sudo mount ${TARGET_DEV} $^
	#sudo chown -R knoppix $^
	sudo touch $@

# Build target directory structure
#mkdir -p usr/bin bin sbin etc tmp proc sys dev boot/grub var/log usr/share usr/src usr/sbin usr/lib lib/modules var/spool var/lock mnt 

TGT_BOOT := ${TARGET_DIR}/boot
${TGT_USR} ${TGT_BOOT}: ${MOUNTED}
	sudo mkdir -p $@
	sudo chmod 755 $@

${TGT_SRC}: ${TGT_USR}
	sudo mkdir -p $@
	sudo chmod 777 $@

ifeq (0,1)

SRC_MAKEFILE := ${TGT_SRC}/Makefile
${SRC_MAKEFILE}: ${TGT_SRC}
	install Makefile.srcdir $@

SRC_COMPLETED := ${TGT_SRC}/.completed.preboot
${SRC_COMPLETED}: ${SRC_MAKEFILE}
	${MAKE} -C ${TGT_SRC} ${SRC_COMPLETED}

${TARGET}: ${SRC_COMPLETED}
	touch $@

# Build kernel
cd /target/usr/src
read -p "Choose a kernel on the next page.  [Continue] " a
lynx kernel.org/pub/linux/kernel/v2.6
LATEST=$(lynx kernel.org/pub/linux/kernel/v2.6 | grep LATEST)
tar xjvf linux-2.6.*.tar.bz2
pushd linux*
cp /boot/config-2.6.* .config
for i in $(lsmod | grep -v Module | cut -d\  -f1 | tr a-z A-Z)
do 
    echo $i
    sed -i "/$i/s/m/y/" .config 
done
sed -i '/MMC/s/m/y/;/SDIO/s/m/y/;/LOCALVERSION/s/""/"-jas1"' .config
#sudo cp .config /target/boot/config-2.6.28.7-jas1
make oldconfig
#find -name \*\.c -exec bzip2 '{}' \;
#sudo make INSTALL_MOD_PATH=/target modules_install
#make
make all INSTALL_MOD_PATH=/target modules_install
#sudo cp arch/x86/boot/bzImage /target/boot/bzImage-2.6.28.7-jas1
cp arch/x86/boot/bzImage /target/boot/bzImage-2.6.28.7-jas1

# Build BusyBox
popd
wget http://www.busybox.net/downloads/busybox-snapshot.tar.bz2
tar xjvf busybox-snapshot.tar.bz2 
pushd busybox
make allyesconfig
patch .config /home/olpc/busybox.allyesconfig.diff
make
#patch busybox/networking/tcpudp.c types.diff
ssudo make install
sudo chmod u+s busybox
cd /media/olpc/usr/src/busybox
make oldconfig
make
#sudo make install
make install
tar xjvf busybox-snapshot.tar.bz2
cd busybox
make allyesconfig

# Build GCC
wget http://gcc.releasenotes.org/releases/gcc-4.3.3/gcc-core-4.3.3.tar.bz2
tar xjvf gcc-4.3.3.tar.bz2
cd gcc-4.3.3
md5sum -c MD5SUMS
./configure --disable-nls --prefix=/media/olpc/usr

endif
