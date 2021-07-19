OBJ_EXT=o

ifeq ($(CONF),Debug)
	LD_SHARED=g++ -shared -pthread -g
else
	LD_SHARED=g++ -shared -pthread
endif

LNK_FLAGS=-Wl,--no-undefined

SRC_PATH=../../gdal/frmts/ecw

OBJ=$(SRC_PATH)/ecwasyncreader.o $(SRC_PATH)/jp2userbox.o $(SRC_PATH)/ecwcreatecopy.o $(SRC_PATH)/ecwdataset.o

PLUGIN_SO =	$(CROCKETT_BIN)/gdal_ECW_JP2ECW.so

$(PLUGIN_SO):	$(OBJ)
	mkdir -p $(CROCKETT_BIN)
	$(LD_SHARED) $(LNK_FLAGS) $(OBJ) $(CONFIG_LIBS) $(EXTRA_LIBS) \
	-o $(PLUGIN_SO)
	objcopy --only-keep-debug $(PLUGIN_SO) $(PLUGIN_SO).debug
	objcopy --strip-debug $(PLUGIN_SO)
	objcopy --strip-unneeded $(PLUGIN_SO)
	CURRENT_DIR=$(pwd)
	cd $(dirname $(PLUGIN_SO))
	objcopy --add-gnu-debuglink  $(PLUGIN_SO).debug $(PLUGIN_SO)
	cd $(CURRENT_DIR)



%.$(OBJ_EXT):	%.c 
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

CC=$(COMPILER_PATH)/bin/gcc
CXX=$(COMPILER_PATH)/bin/g++

CROCKETT_BIN=$(CROCKETT_ROOT)/bin/$(ARCH)linux$(CONF)
CROCKETT_LIB=$(CROCKETT_ROOT)/usr/lib/$(ARCH)linux$(CONF)
CROCKETT_INCLUDE=$(CROCKETT_ROOT)/usr/include/$(ARCH)linux$(CONF)
NCSECW_INCLUDE=$(CROCKETT_INCLUDE)/ecwjp2_sdk
GDAL_LIBS=-L$(CROCKETT_LIB) -lgdal
CONFIG_LIBS=-L$(CROCKETT_LIB) -l$(LIB_NCSECW) $(GDAL_LIBS)
GDAL_INCLUDES=-I$(CROCKETT_INCLUDE)/gcore -I$(CROCKETT_INCLUDE)/port -I$(CROCKETT_INCLUDE)/ogr

LIB_INCLUDES=-I$(CROCKETT_INCLUDE) -I$(NCSECW_INCLUDE)

INCLUDES=$(GDAL_INCLUDES) $(LIB_INCLUDES)

EXTRA_CPPFLAGS := -DFRMT_ecw -DHAVE_COMPRESS -DHAVE_ECW_BUILDNUMBER_H -DGDAL_FORCE_CASHE_CLOSE -DGDAL_COMPILATION -std=c++11 $(EXTRA_CXX_OPTIONS)

ifeq ($(CONF),Debug)
	CPPFLAGS	:=	-g -pthread -fPIC $(INCLUDES) $(EXTRA_CPPFLAGS) 
else
	CPPFLAGS	:=	-pthread -fPIC $(INCLUDES) $(EXTRA_CPPFLAGS) 
endif

plugin:	$(PLUGIN_SO)

default:	$(OBJ:.o=.$(OBJ_EXT))

clean:
	rm -f $(OBJ)
	rm -f $(PLUGIN_SO)

