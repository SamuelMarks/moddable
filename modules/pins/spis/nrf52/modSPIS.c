/*
 * Copyright (c) 2016-2021  Moddable Tech, Inc.
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

#ifndef __MODSPIS_H__
#define __MODSPIS_H__

#include "xsmc.h"
#include "xsHost.h"
#include "mc.xs.h"
#include "mc.defines.h"

#include <string.h>
#include <stdlib.h>

#include "modSPIS.h"
#include "nrfx_spis.h"

#define SPIS_INSTANCE	2

#ifndef MODDEF_SPIS_MOSI_PIN
	#define MODDEF_SPIS_MOSI_PIN	17
#endif
#ifndef MODDEF_SPIS_MISO_PIN
	#define MODDEF_SPIS_MISO_PIN	22
#endif
#ifndef MODDEF_SPIS_SCK_PIN
	#define MODDEF_SPIS_SCK_PIN		28
#endif
#ifndef MODDEF_SPIS_CS_PIN
	#define MODDEF_SPIS_CS_PIN		29
#endif

#ifndef MODDEF_SPIS_BUFFERSIZE
	#define MODDEF_SPIS_BUFFERSIZE	(480*2)		// two lines 240px * 16bit
#endif

static uint8_t *gSPISTxBuffer;

static uint8_t	gSPISInited = 0;

static uint8_t *gUserBuf = NULL;
static uint32_t gUserBufSize = 0;
static uint32_t gUserBufLoc = 0;

static const nrfx_spis_t spis_instance = NRFX_SPIS_INSTANCE(SPIS_INSTANCE);

void SPISDeliver(void *the, void *refcon, uint8_t *message, uint16_t messageLength)
{
	modSPISConfiguration config = refcon;

	gUserBuf = NULL;
	gUserBufSize = gUserBufLoc = 0;
	xsBeginHost(the);
		xsCall0(config->obj, xsID_onReceived);
	xsEndHost(the);
}

void spis_callback(nrfx_spis_evt_t const *event, void *p_context)
{
	int amount, avail;
	modSPISConfiguration config = (modSPISConfiguration)p_context;
	ret_code_t ret;

	if (event->evt_type == NRFX_SPIS_XFER_DONE) {
		gUserBufLoc += event->rx_amount;
		if (gUserBufLoc >= gUserBufSize) {
			modMessagePostToMachineFromISR(config->the, SPISDeliver, config);
		}
		else {
			avail = gUserBufSize - gUserBufLoc;
			amount = avail > MODDEF_SPIS_BUFFERSIZE ? MODDEF_SPIS_BUFFERSIZE : avail;
		
			nrfx_spis_buffers_set(&spis_instance, gSPISTxBuffer, MODDEF_SPIS_BUFFERSIZE, gUserBuf + gUserBufLoc, amount);
		}
	}
}

void xs_spis(xsMachine *the)
{
	int ret;
	modSPISConfiguration config;

	if (gSPISInited)
		return;

	config = c_calloc(1, sizeof(modSPISConfigurationRecord));
	if (!config)
		xsUnknownError("no memory");

	config->the = the;
	config->obj = xsThis;

	config->spis_config.sck_pin = MODDEF_SPIS_SCK_PIN;
	config->spis_config.miso_pin = MODDEF_SPIS_MISO_PIN;
	config->spis_config.mosi_pin = MODDEF_SPIS_MOSI_PIN;
	config->spis_config.csn_pin = MODDEF_SPIS_CS_PIN;
	config->spis_config.mode = NRF_SPIS_MODE_0;
	config->spis_config.bit_order = NRF_SPIS_BIT_ORDER_MSB_FIRST;
//	config->spis_config.csn_pullup = NRFX_SPIS_DEFAULT_CSN_PULLUP;
	config->spis_config.csn_pullup = NRF_GPIO_PIN_NOPULL;
//	config->spis_config.miso_drive = NRFX_SPIS_DEFAULT_MISO_DRIVE;
	config->spis_config.miso_drive = NRF_GPIO_PIN_H0H1;
	config->spis_config.def = NRFX_SPIS_DEFAULT_DEF;
	config->spis_config.orc = NRFX_SPIS_DEFAULT_ORC;
	config->spis_config.irq_priority = 6; // NRFX_SPIS_DEFAULT_CONFIG_IRQ_PRIORITY;
	ret = nrfx_spis_init(&spis_instance, &config->spis_config, spis_callback, config);
	if (ret) {
		c_free(config);
		return;
	}

	gSPISTxBuffer = (uint8_t*)c_calloc(1, MODDEF_SPIS_BUFFERSIZE);

	xsRemember(config->obj);
	xsmcSetHostData(xsThis, config);

	gSPISInited = 1;

	return;
}

void xs_spis_close(xsMachine *the)
{
	modSPISConfiguration config = xsmcGetHostData(xsThis);
	xsForget(config->obj);
	xs_spis_destructor(config);
	xsmcSetHostData(xsThis, NULL);
}

void xs_spis_destructor(void *data)
{
	modSPISConfiguration config = (modSPISConfiguration)data;

	if (NULL == config)
		return;

	if (gSPISInited) {
		// nrf_spis_shutdown
		nrfx_spis_uninit(&spis_instance);

		c_free(config);
		c_free(gSPISTxBuffer);
	
		gSPISInited = 0;
	}
}

void xs_spis_read(xsMachine *the)
{
	modSPISConfiguration config = xsmcGetHostData(xsThis);
	uint8_t *buf = NULL;
	uint32_t bufSize;
	int ret;

	if (xsmcIsInstanceOf(xsArg(0), xsArrayBufferPrototype))
		buf = xsmcToArrayBuffer(xsArg(0));
	else
		buf = xsmcGetHostData(xsArg(0));

	xsmcGet(xsResult, xsArg(0), xsID_byteLength);
	bufSize = xsmcToInteger(xsResult);

	gUserBuf = buf;
	gUserBufSize = bufSize;
	gUserBufLoc = 0;

	if (bufSize > MODDEF_SPIS_BUFFERSIZE)
		bufSize = MODDEF_SPIS_BUFFERSIZE;

	ret = nrfx_spis_buffers_set(&spis_instance, gSPISTxBuffer, bufSize, gUserBuf, bufSize);
}

#endif


