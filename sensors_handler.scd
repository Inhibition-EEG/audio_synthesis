/*
	* by Marinos Koutsomichalis (me@marinoskoutsomichalis.com)
	* Heraklion, 10.2016
	* part of Inhibition SuperCollider code
*/

~sensors_handler = Environment.new;
~sensors_handler.use{
	~is_headset_on = {
		var stdout  = "source /usr/local/bin/gpio.sh && gpio_input XIO_P1; VAL=$? && echo $VAL".unixCmdGetStdOut;
		stdout.asInt.asBoolean.not;
	};
	~get_pot_value = {
		var value = "./read_pot".unixCmdGetStdOut;
		(value.asInt / 1023);
	};
	~led_on = {
		"source /usr/local/bin/gpio.sh && gpio_output CSID1 1".unixCmd;
	};
	~led_off = {
		"source /usr/local/bin/gpio.sh && gpio_output CSID1 0".unixCmd;
	};
	~should_I_power_off = {
		var stdout  = "source /usr/local/bin/gpio.sh && gpio_input XIO_P3; VAL=$? && echo $VAL".unixCmdGetStdOut;
		stdout.asInt.asBoolean.not;
	};
	~power_off = {
		"sudo shutdown -h now".unixCmd;
		0.exit;
	}
}



