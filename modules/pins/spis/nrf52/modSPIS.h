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

#include <xsmc.h>
#include <xsHost.h> 
#include <xsPlatform.h> 
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "nrfx_spis.h"

typedef struct modSPISConfigurationRecord modSPISConfigurationRecord;
typedef struct modSPISConfigurationRecord *modSPISConfiguration;

struct modSPISConfigurationRecord {
	nrfx_spis_config_t	spis_config;
	uint8_t				cs_pin;
	xsMachine 			*the;
	xsSlot				obj;
	uint8_t				*buf;
	uint32_t			bufSize;
	uint32_t			bufLoc;
};

typedef struct modSPISConfigurationRecord modSPISConfigurationRecord;
typedef struct modSPISConfigurationRecord *modSPISConfiguration;

#define modSPISConfig(config, CS_PORT, CS_PIN) \
	config.csn_pin = CS_PIN;

extern void modSPISInit(modSPISConfiguration config);
extern void modSPISUninit(modSPISConfiguration config);

#endif
