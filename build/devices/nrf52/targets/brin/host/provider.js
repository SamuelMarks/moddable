import Analog from "embedded:io/analog";
import Digital from "embedded:io/digital";
import DigitalBank from "embedded:io/digitalbank";
import I2C from "embedded:io/i2c";
import PWM from "embedded:io/pwm";
import Serial from "embedded:io/serial";

const device = {
	I2C: {
		default: {
			io: I2C,
			data: 7,
			clock: 12
		}
	},
	Serial: {
		default: {
			io: Serial,
			port: 1,
			receive: 8,
			transmit: 40
		}
	},
	io: {Analog, Digital, DigitalBank, I2C, PWM, Serial},
	pins: {
		button: 13,
		led: 20
	}
};

export default device;
