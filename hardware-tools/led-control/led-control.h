#ifndef __LEDCONTROL_H__
#define  __LEDCONTROL_H__

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
#ifdef PICOPC
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
#elif defined SPRINKLER
    {
	.id = 1,
	.is_open = 0,
	.fd = -1,
	.name = "Master Brightness Control",
	.path = "/sys/class/leds/control/brightness",
    },
    {
	.id = 2,
	.is_open = 0,
	.fd = -1,
	.name = "Home Led",
	.path = "/sys/class/leds/home/brightness",
    },
    {
	.id = 3,
	.is_open = 0,
	.fd = -1,
	.name = "Water Led",
	.path = "/sys/class/leds/water/brightness",
    },
    {
	.id = 4,
	.is_open = 0,
	.fd = -1,
	.name = "Menu Led",
	.path = "/sys/class/leds/menu/brightness",
    },
    {
	.id = 5,
	.is_open = 0,
	.fd = -1,
	.name = "Back Led",
	.path = "/sys/class/leds/back/brightness",
    },
    {
	.id = 6,
	.is_open = 0,
	.fd = -1,
	.name = "Help Led",
	.path = "/sys/class/leds/help/brightness",
    },
#endif
    { },
};
#endif /* __LEDCONTROL_H__ */