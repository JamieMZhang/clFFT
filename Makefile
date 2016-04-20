# Copyright (C) 2013-2015 Altera Corporation, San Jose, California, USA. All rights reserved.
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to
# whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or
# substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# This agreement shall be governed in all respects by the laws of the State of California and
# by the laws of the United States of America.
# This is a GNU Makefile.

# You must configure ALTERAOCLSDKROOT to point the root directory of the Altera SDK for OpenCL
# software installation.
# See http://www.altera.com/literature/hb/opencl-sdk/aocl_getting_started.pdf
# for more information on installing and configuring the Altera SDK for OpenCL.

ifeq ($(VERBOSE),1)
ECHO :=
else
ECHO := @
endif

# Where is the Altera SDK for OpenCL software?
##ifeq ($(wildcard $(ALTERAOCLSDKROOT)),)
##$(error Set ALTERAOCLSDKROOT to the root directory of the Altera SDK for OpenCL software installation)
##endif
##ifeq ($(wildcard $(ALTERAOCLSDKROOT)/host/include/CL/opencl.h),)
##$(error Set ALTERAOCLSDKROOT to the root directory of the Altera SDK for OpenCL software installation.)
##endif

# OpenCL compile and link flags.
#AOCL_COMPILE_CONFIG := $(shell aocl compile-config )
#AOCL_LINK_CONFIG := $(shell aocl link-config )

# Compilation flags
ifeq ($(DEBUG),1)
CXXFLAGS += -g
else
CXXFLAGS += -O2
endif

# Compiler
CXX := g++

# Target
TARGET := fft1d
TARGET_DIR := .

# Directories
INC_DIRS := /usr/local/cuda/include
LIB_DIRS := /usr/local/lib64

# Files
INCS := $(wildcard host/inc/*.h)
SRCS := fft1d.c
LIBS := OpenCL clFFT

# Make it all
all : $(TARGET_DIR)/$(TARGET)

# Host executable target.
$(TARGET_DIR)/$(TARGET) : Makefile $(SRCS) $(INCS)
	@[ -d $(TARGET_DIR) ] || mkdir $(TARGET_DIR)
	$(CXX) $(CXXFLAGS) $(foreach D,$(INC_DIRS),-I$D) \
			$(SRCS)  \
			$(foreach D,$(LIB_DIRS),-L$D) \
			-o $(TARGET_DIR)/$(TARGET) \
			$(foreach L,$(LIBS),-l$L)

# Standard make targets
clean :
	$(ECHO)rm -f $(TARGET_DIR)/$(TARGET)

.PHONY : all clean
