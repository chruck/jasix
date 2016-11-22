#!/bin/sh -x

set -e

# Script to automate the build of jasix

# Create build environment
sudo yum -y install make gcc pam-devel patch gmp-devel mpfr-devel

# Remove partitions on SD card
#echo -e "d\nd\nw\n" | sudo fdisk /dev/mmcblk0
#sudo ( fdisk /dev/mmcblk0 <<EOF
#sudo fdisk /dev/mmcblk0 <<EOF
#su root fdisk /dev/mmcblk0 <<EOF
#d
#d
#w
#EOF
#)
#sudo { echo -e "d\nd\nw\n" | fdisk /dev/mmcblk0 }
sudo dd if=/dev/zero of=/dev/mmcblk0 bs=1 count=1k
sudo mke2fs -L olpc /dev/mmcblk0
sudo mkdir -p /target
sudo mount /dev/mmcblk0 /target/
cd /target/

# Build target directory structure
sudo chown -R olpc .
#mkdir -p usr/bin bin sbin etc tmp proc sys dev boot/grub var/log usr/share usr/src usr/sbin usr/lib lib/modules var/spool var/lock mnt 
#sudo mkdir -p usr/src
#sudo chown olpc usr/src/
#sudo mkdir -p boot
mkdir -p usr/src boot

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
