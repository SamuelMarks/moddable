#
# Copyright (c) 2016-2022  Moddable Tech, Inc.
#
#   This file is part of the Moddable SDK Tools.
# 
#   The Moddable SDK Tools is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
# 
#   The Moddable SDK Tools is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
# 
#   You should have received a copy of the GNU General Public License
#   along with the Moddable SDK Tools.  If not, see <http://www.gnu.org/licenses/>.
#
#

% : %.c
%.o : %.c

HOST_OS := $(shell uname)

GOAL ?= debug
NAME = tools
ifneq ($(VERBOSE),1)
MAKEFLAGS += --silent
endif

CC = emcc
XS_DIR ?= $(realpath ../../../xs)
BUILD_DIR ?= $(realpath ../..)

COMMODETTO = $(MODDABLE)/modules/commodetto
DATA = $(MODDABLE)/modules/data
INSTRUMENTATION = $(MODDABLE)/modules/base/instrumentation
TOOLS = $(MODDABLE)/tools

BIN_DIR = $(BUILD_DIR)/bin/wasm/$(GOAL)
LIB_DIR = $(BUILD_DIR)/tmp/wasm/$(GOAL)/lib
TMP_DIR = $(BUILD_DIR)/tmp/wasm/$(GOAL)/$(NAME)
MOD_DIR = $(TMP_DIR)/modules

XS_DIRECTORIES = \
	$(XS_DIR)/includes \
	$(XS_DIR)/platforms \
	$(XS_DIR)/sources \
	$(XS_DIR)/tools
	
XS_HEADERS = \
	$(XS_DIR)/platforms/wasm_xs.h \
	$(XS_DIR)/platforms/xsPlatform.h \
	$(XS_DIR)/includes/xs.h \
	$(XS_DIR)/includes/xsmc.h \
	$(XS_DIR)/sources/xsCommon.h \
	$(XS_DIR)/sources/xsAll.h \
	$(XS_DIR)/sources/xsScript.h
	
XS_OBJECTS = \
	$(LIB_DIR)/wasm_xs.c.o \
	$(LIB_DIR)/xsAll.c.o \
	$(LIB_DIR)/xsAPI.c.o \
	$(LIB_DIR)/xsArguments.c.o \
	$(LIB_DIR)/xsArray.c.o \
	$(LIB_DIR)/xsAtomics.c.o \
	$(LIB_DIR)/xsBigInt.c.o \
	$(LIB_DIR)/xsBoolean.c.o \
	$(LIB_DIR)/xsCode.c.o \
	$(LIB_DIR)/xsCommon.c.o \
	$(LIB_DIR)/xsDataView.c.o \
	$(LIB_DIR)/xsDate.c.o \
	$(LIB_DIR)/xsDebug.c.o \
	$(LIB_DIR)/xsError.c.o \
	$(LIB_DIR)/xsFunction.c.o \
	$(LIB_DIR)/xsGenerator.c.o \
	$(LIB_DIR)/xsGlobal.c.o \
	$(LIB_DIR)/xsJSON.c.o \
	$(LIB_DIR)/xsLexical.c.o \
	$(LIB_DIR)/xsMapSet.c.o \
	$(LIB_DIR)/xsMarshall.c.o \
	$(LIB_DIR)/xsMath.c.o \
	$(LIB_DIR)/xsMemory.c.o \
	$(LIB_DIR)/xsModule.c.o \
	$(LIB_DIR)/xsNumber.c.o \
	$(LIB_DIR)/xsObject.c.o \
	$(LIB_DIR)/xsPlatforms.c.o \
	$(LIB_DIR)/xsProfile.c.o \
	$(LIB_DIR)/xsPromise.c.o \
	$(LIB_DIR)/xsProperty.c.o \
	$(LIB_DIR)/xsProxy.c.o \
	$(LIB_DIR)/xsRegExp.c.o \
	$(LIB_DIR)/xsRun.c.o \
	$(LIB_DIR)/xsScope.c.o \
	$(LIB_DIR)/xsScript.c.o \
	$(LIB_DIR)/xsSourceMap.c.o \
	$(LIB_DIR)/xsString.c.o \
	$(LIB_DIR)/xsSymbol.c.o \
	$(LIB_DIR)/xsSyntaxical.c.o \
	$(LIB_DIR)/xsTree.c.o \
	$(LIB_DIR)/xsType.c.o \
	$(LIB_DIR)/xsdtoa.c.o \
	$(LIB_DIR)/xsmc.c.o \
	$(LIB_DIR)/xsre.c.o \
	$(LIB_DIR)/xsa.c.o \
	$(LIB_DIR)/xsc.c.o \
	$(LIB_DIR)/xslBase.c.o

MODULES = \
	$(MOD_DIR)/commodetto/Bitmap.xsb \
	$(MOD_DIR)/commodetto/BMPOut.xsb \
	$(MOD_DIR)/commodetto/BufferOut.xsb \
	$(MOD_DIR)/commodetto/ColorCellOut.xsb \
	$(MOD_DIR)/commodetto/Convert.xsb \
	$(MOD_DIR)/commodetto/ParseBMF.xsb \
	$(MOD_DIR)/commodetto/ParseBMP.xsb \
	$(MOD_DIR)/commodetto/PixelsOut.xsb \
	$(MOD_DIR)/commodetto/Poco.xsb \
	$(MOD_DIR)/commodetto/PocoCore.xsb \
	$(MOD_DIR)/commodetto/ReadJPEG.xsb \
	$(MOD_DIR)/commodetto/ReadPNG.xsb \
	$(MOD_DIR)/commodetto/RLE4Out.xsb \
	$(MOD_DIR)/wavreader.xsb \
	$(MOD_DIR)/file.xsb \
	$(MOD_DIR)/cdv.xsb \
	$(MOD_DIR)/colorcellencode.xsb \
	$(MOD_DIR)/compileDataView.xsb \
	$(MOD_DIR)/compressbmf.xsb \
	$(MOD_DIR)/image2cs.xsb \
	$(MOD_DIR)/mcconfig.xsb \
	$(MOD_DIR)/mclocal.xsb \
	$(MOD_DIR)/mcmanifest.xsb \
	$(MOD_DIR)/mcrez.xsb \
	$(MOD_DIR)/png2bmp.xsb \
	$(MOD_DIR)/resampler.xsb \
	$(MOD_DIR)/rle4encode.xsb \
	$(MOD_DIR)/tool.xsb \
	$(MOD_DIR)/unicode-ranges.xsb \
	$(MOD_DIR)/wav2maud.xsb \
	$(MOD_DIR)/bles2gatt.xsb \
	$(TMP_DIR)/commodettoBitmap.c.xsi \
	$(TMP_DIR)/commodettoBufferOut.c.xsi \
	$(TMP_DIR)/commodettoColorCellOut.c.xsi \
	$(TMP_DIR)/commodettoConvert.c.xsi \
	$(TMP_DIR)/commodettoParseBMF.c.xsi \
	$(TMP_DIR)/commodettoParseBMP.c.xsi \
	$(TMP_DIR)/commodettoPocoCore.c.xsi \
	$(TMP_DIR)/commodettoPocoBlit.c.xsi \
	$(TMP_DIR)/commodettoReadJPEG.c.xsi \
	$(TMP_DIR)/commodettoReadPNG.c.xsi \
	$(TMP_DIR)/cfeBMF.c.xsi \
	$(TMP_DIR)/image2cs.c.xsi \
	$(TMP_DIR)/miniz.c.xsi \
	$(TMP_DIR)/modInstrumentation.c.xsi \
	$(TMP_DIR)/tool.c.xsi
PRELOADS =\
	-p commodetto/Bitmap.xsb\
	-p commodetto/BMPOut.xsb\
	-p commodetto/BufferOut.xsb\
	-p commodetto/ColorCellOut.xsb\
	-p commodetto/Convert.xsb\
	-p commodetto/ParseBMF.xsb\
	-p commodetto/ParseBMP.xsb\
	-p commodetto/Poco.xsb\
	-p commodetto/PocoCore.xsb\
	-p commodetto/ReadPNG.xsb\
	-p commodetto/RLE4Out.xsb\
	-p wavreader.xsb\
	-p resampler.xsb\
	-p unicode-ranges.xsb\
	-p file.xsb
CREATION = -c 134217728,16777216,8388608,1048576,16384,16384,0,1993,127,32768,1993,0,main

HEADERS = \
	$(COMMODETTO)/commodettoBitmap.h \
	$(COMMODETTO)/commodettoPocoBlit.h \
	$(INSTRUMENTATION)/modInstrumentation.h
OBJECTS = \
	$(TMP_DIR)/adpcm-lib.c.o \
	$(TMP_DIR)/adpcm-dns.c.o \
	$(TMP_DIR)/commodettoBitmap.c.o \
	$(TMP_DIR)/commodettoBufferOut.c.o \
	$(TMP_DIR)/commodettoColorCellOut.c.o \
	$(TMP_DIR)/commodettoConvert.c.o \
	$(TMP_DIR)/commodettoParseBMF.c.o \
	$(TMP_DIR)/commodettoParseBMP.c.o \
	$(TMP_DIR)/commodettoPocoCore.c.o \
	$(TMP_DIR)/commodettoPocoBlit.c.o \
	$(TMP_DIR)/commodettoReadJPEG.c.o \
	$(TMP_DIR)/commodettoReadPNG.c.o \
	$(TMP_DIR)/cfeBMF.c.o \
	$(TMP_DIR)/image2cs.c.o \
	$(TMP_DIR)/miniz.c.o \
	$(TMP_DIR)/modInstrumentation.c.o \
	$(TMP_DIR)/tool.c.o \
	$(TMP_DIR)/wav2maud.c.o

ifeq ($(wildcard $(TOOLS)/mcrun.js),) 
else 
  MODULES += $(MOD_DIR)/mcrun.xsb
endif 

TOOLS_VERSION ?= $(shell cat $(MODDABLE)/tools/VERSION)

C_DEFINES = \
	-DXS_ARCHIVE=1 \
	-DINCLUDE_XSPLATFORM=1 \
	-DXSPLATFORM=\"wasm_xs.h\" \
	-DXSTOOLS=1 \
	-DmxRun=1 \
	-DmxParse=1 \
	-DmxNoFunctionLength=1 \
	-DmxNoFunctionName=1 \
	-DmxHostFunctionPrimitive=1 \
	-DmxFewGlobalsTable=1 \
	-DkModdableToolsVersion=\"$(TOOLS_VERSION)\"
ifeq ($(GOAL),debug)
	C_DEFINES += -DMODINSTRUMENTATION=1 -DmxInstrument=1
endif
C_INCLUDES += $(foreach dir,$(XS_DIRECTORIES) $(INSTRUMENTATION) $(COMMODETTO) $(TOOLS) $(TMP_DIR),-I$(dir))
# C_FLAGS = -c -arch i386
C_FLAGS = -c
ifeq ($(GOAL),debug)
	C_FLAGS += -D_DEBUG=1 -DmxDebug=1 -g -O0 -Wall -Wextra -Wno-missing-field-initializers -Wno-unused-parameter
else
	C_FLAGS += -D_RELEASE=1 -O3
endif

LIBRARIES = -ldl -lm

# LINK_FLAGS = -arch i386
LINK_FLAGS =\
	-s ENVIRONMENT=web\
	-s ALLOW_MEMORY_GROWTH=1\
	-s MODULARIZE=1\
	-s EXPORT_ES6=1\
	-s USE_ES6_IMPORT_META=0\
	-s EXPORT_NAME=$(NAME)\
	-s INVOKE_RUN=0\
	-s FORCE_FILESYSTEM=1\
	-s ERROR_ON_UNDEFINED_SYMBOLS=0\
	-s "EXPORTED_RUNTIME_METHODS=['FS', 'cwrap', 'ccall', 'callMain', 'ALLOC_NORMAL','ALLOC_STACK']"
ifeq ($(GOAL),release)
	LINK_OPTIONS += -Oz
endif

ifeq ($(HOST_OS),Darwin)
MODDABLE_TOOLS_DIR = $(BUILD_DIR)/bin/mac
else
MODDABLE_TOOLS_DIR = $(BUILD_DIR)/bin/lin
endif

XSC = $(MODDABLE_TOOLS_DIR)/release/xsc
XSID = $(MODDABLE_TOOLS_DIR)/release/xsid
XSL = $(MODDABLE_TOOLS_DIR)/release/xsl
	
VPATH += $(XS_DIRECTORIES) $(COMMODETTO) $(INSTRUMENTATION) $(DATA)/wavreader $(TOOLS)

build: $(LIB_DIR) $(TMP_DIR) $(MOD_DIR) $(MOD_DIR)/commodetto $(BIN_DIR) $(BIN_DIR)/$(NAME)

$(LIB_DIR):
	mkdir -p $(LIB_DIR)
	
$(TMP_DIR):
	mkdir -p $(TMP_DIR)
	
$(MOD_DIR):
	mkdir -p $(MOD_DIR)
	
$(MOD_DIR)/commodetto:
	mkdir -p $(MOD_DIR)/commodetto
	
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(BIN_DIR)/$(NAME): $(XS_OBJECTS) $(OBJECTS) $(TMP_DIR)/mc.xs.c.o
	@echo "#" $(NAME) $(GOAL) ": cc" $(@F)
	$(CC) -O2 $(LINK_FLAGS) $(LIBRARIES) $(XS_OBJECTS) $(OBJECTS) $(TMP_DIR)/mc.xs.c.o -o $@.js

$(XS_OBJECTS) : $(XS_HEADERS)
$(LIB_DIR)/%.c.o: %.c
	@echo "#" $(NAME) $(GOAL) ": cc" $(<F)
	$(CC) $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) $< -o $@

$(TMP_DIR)/mc.xs.c.o: $(TMP_DIR)/mc.xs.c $(HEADERS)
	@echo "#" $(NAME) $(GOAL) ": cc" $(<F)
	$(CC) $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) $< -o $@
	
$(TMP_DIR)/mc.xs.c: $(MODULES)
	@echo "#" $(NAME) $(GOAL) ": xsl modules"
	$(XSL) -b $(MOD_DIR) -o $(TMP_DIR) $(PRELOADS) $(CREATION) $(MODULES)

$(MOD_DIR)/commodetto/%.xsb: $(COMMODETTO)/commodetto%.js
	@echo "#" $(NAME) $(GOAL) ": xsc" $(<F)
	$(XSC) $< -c -d -e -o $(MOD_DIR)/commodetto -r $*

$(MOD_DIR)/%.xsb: $(DATA)/wavreader/%.js
	@echo "#" $(NAME) $(GOAL) ": xsc" $(<F)
	$(XSC) $< -c -d -e -o $(MOD_DIR) -r $*

$(MOD_DIR)/%.xsb: $(TOOLS)/%.js
	@echo "#" $(NAME) $(GOAL) ": xsc" $(<F)
	$(XSC) -c -d -e $< -o $(MOD_DIR)

$(OBJECTS): $(XS_HEADERS) $(HEADERS) | $(TMP_DIR)/mc.xs.c
$(TMP_DIR)/tool.c.o : $(MODDABLE)/tools/VERSION
$(TMP_DIR)/%.c.o: %.c
	@echo "#" $(NAME) $(GOAL) ": cc" $(<F)
	$(CC) $< $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -c -o $@

$(TMP_DIR)/%.c.xsi: %.c
	@echo "#" $(NAME) $(GOAL) ": xsid" $(<F)
	$(XSID) $< -o $(TMP_DIR)

clean:
	rm -rf $(BUILD_DIR)/bin/wasm/debug/$(NAME).*
	rm -rf $(BUILD_DIR)/bin/wasm/release/$(NAME).*
	rm -rf $(BUILD_DIR)/tmp/wasm/debug/$(NAME)
	rm -rf $(BUILD_DIR)/tmp/wasm/release/$(NAME)
