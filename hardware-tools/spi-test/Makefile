TOOLCHAIN=/indevel/minibox-android/arm-toolchains/codesourcery/arm-2009q3
KERNELDIR=/indevel/minibox-android/android-kernel/kernel-android-atmel-2.6.32
CC=$(TOOLCHAIN)/bin/arm-none-linux-gnueabi-gcc
STRIP=$(TOOLCHAIN)/bin/arm-none-linux-gnueabi-strip
CFLAGS=-Wall -I$(KERNELDIR)/ -I$(TOOLCHAIN)/arm-none-linux-gnueabi/include/ 
LDFLAGS=-L$(TOOLCHAIN)/arm-none-linux-gnueabi/lib/
SRC=spidev_test.c
OBJ=spidev_test.o
BIN=spidev_test

all:
	$(CC) $(CFLAGS) -c $(SRC) -o $(OBJ)
	$(CC) $(LDFLAGS) $(OBJ) -static -o $(BIN)
	$(STRIP) $(BIN)

clean:
	rm -v $(OBJ)
	rm -v $(BIN)

