.PHONY: clean libuv mbedtls test_ext

PROJECT   := c4irp
export CC := clang

COMMON    := config.h c4chirp/common.h
# CFLAGS    := -O3 -DNDEBUG


include home/Makefile

config.h:
	cp config.defs.h config.h

test_ext: array_test
	./array_test 2>&1 | grep Bufferoverflow

libuv/configure:
	cd libuv && ./autogen.sh

libuv/Makefile: libuv/configure
	cd libuv && ./configure

libuv/.libs/libuv.a: libuv/Makefile
	make -C libuv

libuv: libuv/.libs/libuv.a

mbedtls/library/libmbedtls.a:
	make -C mbedtls

mbedtls: mbedtls/library/libmbedtls.a


%.o: %.h %.c $(COMMON)
	$(CC) -std=c99 -c -o $@ $< $(CFLAGS)

array_test: c4irp/array_test.o
	$(CC) -std=c99 -o $@ $< $(CFLAGS)

clean:
	git clean -xdf
	cd libuv && git clean -xdf
	cd mbedtls && git clean -xdf

