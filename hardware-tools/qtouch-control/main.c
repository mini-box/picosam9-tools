/*  Small test for Atmel QTouch board based on AT42QT1060
*   (c) 2011 Nicu Pavel <npavel@ituner.com>
*/

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <limits.h>
#include <sys/ioctl.h>
#include <linux/i2c-dev.h>

#define ATMEL_QTOUCH_ADDR 0x12
#define I2C_NR 0

static char * dec8bit(int dec)
{

    char *bin = (char *) malloc(9);
    int pos = 7;

    while(dec >= 0 && pos >= 0)
    {
	if(dec % 2 == 0)
	    bin[pos] = '0';
	else
	    bin[pos] = '1';
	dec = dec/2;
	pos--;
    }
    bin[8] = '\0';
    return bin;
}

static int i2c_read(int fd, unsigned char *buf, int len)
{

    unsigned char addr = buf[0];
    
    if (read(fd, buf, len) != len) 
    {
	fprintf(stderr, "Can't read from address %d\n", addr);
	return 0;
    }
    
    fprintf(stdout, "Read from address %d: %s(%d)\n", addr, dec8bit(buf[0]), buf[0]);
    
    return 1;
}


static int i2c_write(int fd, unsigned char *buf, int len)
{

    if (write(fd, buf, len) != len) 
    {
	fprintf(stderr, "Can't write to address %d\n", buf[0]);
	return 0;
    }
    
    return 1;
}


int device_read(int fd, unsigned char reg)
{
    i2c_write(fd, &reg, 1);
    i2c_read(fd, &reg, 1);
    
    return 1;
}


int main(int argc, char *argv[])
{
    int file;
    int i2c_bus = I2C_NR;
    char filename[20];
    
    if (argc < 2) 
	fprintf(stderr, "No i2c bus specified, using bus: %d\n", i2c_bus);
    else
	i2c_bus = strtol(argv[1], (char **)NULL, 10);

    if ((errno == ERANGE && (i2c_bus == LONG_MAX || i2c_bus == LONG_MIN))
           || (errno != 0 && i2c_bus == 0)) 
    {
	perror("strtol");
        exit(EXIT_FAILURE);
    }

    snprintf(filename, 19, "/dev/i2c-%d", i2c_bus);
    file = open(filename, O_RDWR);
    if (file < 0)
    {
	fprintf(stderr, "Error opening %s device\n", filename);
	return 1;
    }

    if (ioctl(file, I2C_SLAVE, ATMEL_QTOUCH_ADDR) < 0)
    {
	fprintf(stderr, "Can't set i2c slave addr\n");
	return 2;
    }
    device_read(file, 0x00);
    device_read(file, 0x01);
    device_read(file, 0x02);
    device_read(file, 0x04);
    device_read(file, 0x05);
    
    fflush(stdout);
    fflush(stderr);
    /* add a small delay before exiting usefull in burn in tests */
    usleep(100000);
    
    return 0;
}