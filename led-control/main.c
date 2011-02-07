#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

struct led_info
{
    int id;
    int is_open;
    int fd;
    char *name;
    char *path;
};

static struct led_info leds[] =
{
    {
	.id = 1,
	.is_open = 0,
	.fd = -1,
	.name = "User led 1",
	.path = "/sys/class/leds/d6/brightness",
    },
    {
    	.id = 2,
	.is_open = 0,
	.fd = -1,
	.name = "User led 2",
	.path = "/sys/class/leds/d7/brightness",
    },
    {
    	.id = 3,
	.is_open = 0,
	.fd = -1,
	.name = "User led 3",
	.path = "/sys/class/leds/d8/brightness",
    },
    
    { },
};

static int open_leds(void)
{
    struct led_info *l;
    int fd;
    int found = 0;
    
    for (l = leds; l->path != NULL; ++l)
    {
	if ((fd = open(l->path, O_RDWR)) < 0)
	{
	    fprintf(stderr,"Failed to open %s\n", l->path);
	    continue;
	}

	l->fd = fd;
	l->is_open = 1;
	found++;
    }
    
    return found;
}

static int close_leds(void)
{
    struct led_info *l;
    
    for (l = leds; l->path != NULL; ++l)
    {
	if (l->is_open)
	{
	    close(l->fd);
	}
    }
    
    return 1;
}

static int send_leds(value)
{
    struct led_info *l;
    char str[20];
    int len, ret;
    
    len = snprintf(str, 20, "%d\n", value);
    for (l = leds; l->path != NULL; ++l)
	if (l->is_open)
	{
	    ret = write(l->fd, str, len);
	    fsync(l->fd);
	}
    
    return (ret == len) ? 0 : -1;
}

int main (int argc, char *argv[])
{
    char *str, *endstr;
    long int val;
    
    if (argc < 2)
    {
	fprintf(stderr, "Usage:  -1 leds closed\n" \
	"\t 0 leds opened\n \t <n> leds blinking n times per second\n");
	return 1;
    }
    
    str = argv[1];
    val = strtol(str, &endstr, 10);
    if (endstr == str)
    {
	fprintf(stderr, "Invalid number\n");
	return 1;
    }

    if (!open_leds())
	return 1;
    
    if (val == -1)
    {
	send_leds(0);
	close_leds();
	return 0;
    }
    
    if (val == 0)
    {
	send_leds(200);
	close_leds();
	return 0;
    }
    
    if (val > 0)
    {
	while (1)
	{
	    send_leds(200);
	    usleep(1000/val * 1000);
	    send_leds(0);
	    usleep(1000/val * 1000);
	}
    }

    close_leds();
    
    return 0;
}