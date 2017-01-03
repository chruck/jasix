# Makefile for 2-build_sw_pre-chroot

TARGET := blah

all: ${TARGET}

TARGET_DIR := /target
TGT_USR := ${TARGET_DIR}/usr
TGT_SRC := ${TGT_USR}/src
SRC_MAKEFILE := ${TGT_SRC}/Makefile
${SRC_MAKEFILE}: ${TGT_SRC}
	install Makefile.srcdir $@

SRC_COMPLETED := ${TGT_SRC}/.completed.preboot
${SRC_COMPLETED}: ${SRC_MAKEFILE}
	${MAKE} -C ${TGT_SRC} ${SRC_COMPLETED}

${TARGET}: ${SRC_COMPLETED}
	touch $@
