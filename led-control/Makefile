TOOLCHAIN=/indevel/minibox-android/arm-toolchains/codesourcery/arm-2009q3
CC=$(TOOLCHAIN)/bin/arm-none-linux-gnueabi-gcc
STRIP=$(TOOLCHAIN)/bin/arm-none-linux-gnueabi-strip
CFLAGS=-Wall -I$(TOOLCHAIN)/arm-none-linux-gnueabi/include/
LDFLAGS=-L$(TOOLCHAIN)/arm-none-linux-gnueabi/lib/
SRC=main.c
OBJ=main.o
BIN=leds-control

all:
	$(CC) $(CFLAGS) -c $(SRC) -o $(OBJ)
	$(CC) $(LDFLAGS) $(OBJ) -static -o $(BIN)
	$(STRIP) $(BIN)

clean:
	rm -v $(OBJ)
	rm -v $(BIN)

