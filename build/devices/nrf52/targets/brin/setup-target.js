/*
 * Copyright (c) 2018-2020  Moddable Tech, Inc.
 *
 *   This file is part of the Moddable SDK Runtime.
 *
 *   The Moddable SDK Runtime is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Lesser General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   The Moddable SDK Runtime is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Lesser General Public License for more details.
 *
 *   You should have received a copy of the GNU Lesser General Public License
 *   along with the Moddable SDK Runtime.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

import config from "mc/config";
import Digital from "pins/digital";
import Button from "button";
import LED from "led";
import Timer from "timer";

globalThis.Host = {
	LED: class {
		constructor(options) {
			return new LED({
				...options,
				pin: config.led1_pin,
			});
		}
	},
	Button: class {
		constructor(options) {
			return new Button({
				...options,
				invert: true,
				pin: config.button1_pin,
				mode: Digital.InputPullUp,
			});
		}
	},
	pins: {
		led: config.led1_pin,
		button: config.button1_pin,
	}
};
Object.freeze(Host, true);

export default function (done) {
	if (config.autobacklight) {
//trace("auto-backlight - turn on power to display\n");
		Digital.write(config.disp_reset, 1);
		Digital.write(config.disp_pwr_en, 1);
		Timer.delay(10);
		Digital.write(config.disp_reset, 0);
		Timer.delay(50);
		Digital.write(config.disp_reset, 1);
		Timer.delay(120);
	}
	Digital.write(config.led1_pin, 1);	// turn off leds
	Digital.write(config.led2_pin, 1);

	done();
}
