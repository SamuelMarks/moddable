#
# Copyright (c) 2016-2023  Moddable Tech, Inc.
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
.NOTPARALLEL:

ifndef MODDABLE
$(error MODDABLE environment variable not set)
endif

ifneq ($(MODDABLE), $(abspath $(MODDABLE)))
$(error MODDABLE environment variable is set to an invalid path: "$(MODDABLE)")
endif

XS_DIR ?= $(MODDABLE)/xs
export XS_DIR
BUILD_DIR ?= $(MODDABLE)/build
export BUILD_DIR

all: release

debug:
	make -f $(XS_DIR)/makefiles/mac/xsc.mk
	make -f $(XS_DIR)/makefiles/mac/xsid.mk
	make -f $(XS_DIR)/makefiles/mac/xsl.mk
	make -f serial2xsbug.mk
	make -f tools.mk
	$(MODDABLE)/build/bin/mac/debug/mcconfig -d -m -p x-mac $(MODDABLE)/tools/xsbug/manifest.json
	$(MODDABLE)/build/bin/mac/debug/mcconfig -d -m -p x-mac $(MODDABLE)/tools/mcsim/manifest.json
	
release:
	make GOAL=release -f $(XS_DIR)/makefiles/mac/xsc.mk
	make GOAL=release -f $(XS_DIR)/makefiles/mac/xsid.mk
	make GOAL=release -f $(XS_DIR)/makefiles/mac/xsl.mk
	make GOAL=release -f serial2xsbug.mk
	make GOAL=release -f tools.mk
	$(MODDABLE)/build/bin/mac/release/mcconfig -m -p x-mac $(MODDABLE)/tools/xsbug/manifest.json
	$(MODDABLE)/build/bin/mac/release/mcconfig -m -p x-mac $(MODDABLE)/tools/mcsim/manifest.json
	
clean:
	make clean -f $(XS_DIR)/makefiles/mac/xsc.mk
	make clean -f $(XS_DIR)/makefiles/mac/xsid.mk
	make clean -f $(XS_DIR)/makefiles/mac/xsl.mk
	make clean -f serial2xsbug.mk
	make clean -f tools.mk
	rm -rf $(MODDABLE)/build/bin $(MODDABLE)/build/tmp
