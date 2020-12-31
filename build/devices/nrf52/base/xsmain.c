/*
 * Copyright (c) 2016-2020  Moddable Tech, Inc.
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

#include "xs.h"
#include "xsmain.h"
#include "modTimer.h"
#include "modInstrumentation.h"

#include "xsPlatform.h"
#include "xsHost.h"

#ifdef mxDebug
	static xsMachine *gThe = NULL;		// main VM
	TaskHandle_t gMainTask = NULL;
#endif

static void xsTask(void *pvParameter);

#define kStack ((10 * 1024) / sizeof(StackType_t))
#define kTaskPriority	1

void xs_setup(void)
{
#if configSUPPORT_STATIC_ALLOCATION
	static StaticTask_t taskBuffer;
	static StackType_t stackBuffer[kStack];
	xTaskCreateStatic(xsTask, "main", kStack, NULL, kTaskPriority, stackBuffer, &taskBuffer);
#else
	xTaskCreate(xsTask, "main", kStack, NULL, kTaskPriority, NULL);
#endif
}

void xsTask(void *pvParameter)
{
	xsMachine *the;

#ifdef mxDebug
	gMainTask = xTaskGetCurrentTaskHandle();
	setupDebugger();
#endif

	the = ESP_cloneMachine(0, 0, 0, 0);
#ifdef mxDebug
	gThe = the;
#endif

	mc_setup(the);

	while (1) {
		modTimersExecute();
		modMessageService(the, modTimersNext());

		modInstrumentationAdjust(Turns, +1);
	}
}

void modLog_transmit(const char *msg)
{
	uint8_t c;

#ifdef mxDebug
	if (gThe) {
		while (0 != (c = c_read8(msg++)))
			fx_putc(gThe, c);
		fx_putc(gThe, 0);
	}
	else
#endif
	{
		while (0 != (c = c_read8(msg++)))
			ESP_putc(c);
		ESP_putc('\r');
		ESP_putc('\n');
	}
}

