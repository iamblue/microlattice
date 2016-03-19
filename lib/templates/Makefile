SOURCE_DIR = ../../../../..
BINPATH    = ~/gcc-arm-none-eabi/bin

PWD        = $(shell pwd)

FEATURE    ?= feature.mk

include $(FEATURE)

# Gloabl Config
-include $(SOURCE_DIR)/.config
# IC Config
-include $(SOURCE_DIR)/config/chip/$(IC_CONFIG)/chip.mk
# Board Config
-include $(SOURCE_DIR)/config/board/$(BOARD_CONFIG)/board.mk

RAM_BOOTING=0

DEBUG      = 0
FLOAT_TYPE = hard
BUILD_DIR  = $(PWD)/Build

# Project name
PROJ_NAME = mt7687_iot_sdk
PROJ_PATH = $(PWD)
OUTPATH = $(PWD)/Build

# lzma files
LIBS += $(SOURCE_DIR)/middleware/third_party/lzma_decoder/lib/liblzma.a

# Main APP files
APP_PATH = project/mt7687_hdk/apps/iot_sdk
APP_PATH_SRC = $(APP_PATH)/src
APP_FILES = $(APP_PATH_SRC)/main.c \
			$(APP_PATH_SRC)/cli_def.c \
			$(APP_PATH_SRC)/io_def.c \
			$(APP_PATH_SRC)/task_def.c \
			$(APP_PATH_SRC)/net_init.c \
			$(APP_PATH)/GCC/syscalls.c

ifeq ($(MTK_JR_ENABLE),y)
APP_FILES += $(APP_PATH_SRC)/jerry-port.c
endif

ifeq ($(MTK_HOMEKIT_ENABLE),y)
APP_FILES += $(APP_PATH_SRC)/homekit_init.c
endif

# =============================================
# for javascript
# =============================================

<%= APP_FILES %>

# =============================================

C_FILES += $(APP_FILES)
C_FILES += $(APP_PATH_SRC)/system_mt7687.c


# add startup file to build
S_FILES += $(APP_PATH)/GCC/startup_mt7687.s



C_OBJS = $(C_FILES:%.c=$(BUILD_DIR)/%.o)
S_OBJS = $(S_FILES:%.s=$(BUILD_DIR)/%.o)

CFLAGS += -DMTK_FW_VERSION=\"$(MTK_FW_VERSION)\"

DATIME = $(shell date --iso=seconds)
CFLAGS += -DMTK_FW_VERSION=\"$(MTK_FW_VERSION)\"

###################################################
# include path
CFLAGS += -I$(SOURCE_DIR)/$(APP_PATH)/inc
CFLAGS += -I$(SOURCE_DIR)/driver/chip/mt7687/inc
CFLAGS += -I$(SOURCE_DIR)/driver/chip/inc
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/lwip/src/include
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/lwip/ports/include

###################################################
# jerryscript

CFLAGS += -I$(SOURCE_DIR)/middleware/jerryscript/inc/vm
CFLAGS += -I$(SOURCE_DIR)/middleware/jerryscript/inc/parser
CFLAGS += -I$(SOURCE_DIR)/middleware/jerryscript/inc/parser/regexp
CFLAGS += -I$(SOURCE_DIR)/middleware/jerryscript/inc/parser/js
CFLAGS += -I$(SOURCE_DIR)/middleware/jerryscript/inc/parser/js/bc
CFLAGS += -I$(SOURCE_DIR)/middleware/jerryscript/inc/parser/js/collections
CFLAGS += -I$(SOURCE_DIR)/middleware/jerryscript/inc/ecma
CFLAGS += -I$(SOURCE_DIR)/middleware/jerryscript/inc/ecma/operations
CFLAGS += -I$(SOURCE_DIR)/middleware/jerryscript/inc/ecma/base
CFLAGS += -I$(SOURCE_DIR)/middleware/jerryscript/inc/ecma/builtin-objects
CFLAGS += -I$(SOURCE_DIR)/middleware/jerryscript/inc/rcs
CFLAGS += -I$(SOURCE_DIR)/middleware/jerryscript/inc/jrt
CFLAGS += -I$(SOURCE_DIR)/middleware/jerryscript/inc/mem
CFLAGS += -I$(SOURCE_DIR)/middleware/jerryscript/inc/lit

###################################################

###################################################
# LD Flags
LDFLAGS = $(ALLFLAGS) $(FPUFLAGS) --specs=nano.specs -lnosys -nostartfiles -u _printf_float -u _scanf_float 
ifeq ($(RAM_BOOTING), 1)
LDFLAGS += -Wl,-Tmt7687_sram.ld -Wl,--gc-sections
else
LDFLAGS += -Wl,-Tmt7687_flash.ld -Wl,--gc-sections
endif

LDFLAGS += -Wl,-wrap=printf

###################################################
# Libraries
ifeq ($(MTK_HOMEKIT_ENABLE),y)
LIBS += $(SOURCE_DIR)/middleware/MTK/homekit/lib/libhomekit.a
LIBS += $(OUTPATH)/libjsonc.a
LIBS += $(OUTPATH)/libed25519.a
LIBS += $(OUTPATH)/libchacha20poly1305.a
LIBS += $(OUTPATH)/libcurve25519.a
LIBS += $(OUTPATH)/libsrp.a
endif
LIBS += $(OUTPATH)/libcjson.a
LIBS += $(OUTPATH)/libhttpclient.a
LIBS += $(OUTPATH)/libmbedtls.a
LIBS += $(SOURCE_DIR)/middleware/MTK/minicli/lib/libminicli.a
ifeq ($(MTK_WIFI_WPS_ENABLE),y)
LIBS += $(SOURCE_DIR)/middleware/MTK/minisupp/lib/libminisupp_wps.a
else
LIBS += $(SOURCE_DIR)/middleware/MTK/minisupp/lib/libminisupp.a
endif
LIBS += $(OUTPATH)/libmqtt.a
LIBS += $(OUTPATH)/libnghttp2.a
ifeq ($(MTK_NVRAM_ENABLE),y)
LIBS += $(SOURCE_DIR)/middleware/MTK/nvram/lib/libnvram.a
endif
LIBS += $(OUTPATH)/libsntp.a
LIBS += $(OUTPATH)/libxml.a
LIBS += $(OUTPATH)/libiperf.a
LIBS += $(OUTPATH)/librtos.a
LIBS += $(OUTPATH)/libbspex.a
LIBS += $(OUTPATH)/libbsp.a
LIBS += $(SOURCE_DIR)/driver/board/mt76x7_hdk/lib/libbsp_sec.a
LIBS += $(OUTPATH)/libsmtcn.a
LIBS += $(SOURCE_DIR)/middleware/MTK/smtcn/lib/libsmtcn_core.a
LIBS += $(SOURCE_DIR)/kernel/service/lib/libservice_core.a
LIBS += $(OUTPATH)/libservice.a
LIBS += $(OUTPATH)/libping.a
LIBS += $(OUTPATH)/liblwip.a
LIBS += $(SOURCE_DIR)/driver/chip/mt7687/lib/libhal_core.a
LIBS += $(OUTPATH)/libhal.a
LIBS += $(SOURCE_DIR)/driver/chip/mt7687/lib/libhal_sec.a
LIBS += $(OUTPATH)/libdhcpd.a
LIBS += $(OUTPATH)/libfota.a
LIBS += $(OUTPATH)/libtftp.a

ifeq ($(MTK_JR_ENABLE),y)
# Jerryscript (Javascript Engine)
LIBS += $(SOURCE_DIR)/middleware/jerryscript/lib/librelease-cp.jerry-core.a
endif

###################################################
# Rules
.PHONY: libs proj clean

all: libs proj
	@mkdir -p $(BUILD_DIR)
	@$(SIZE) $(OUTPATH)/$(PROJ_NAME)_xip.elf
	@echo "Generate Assembly from elf:"
	#@echo cp $(SOURCE_DIR)/$(APP_PATH)/download_config/* $(OUTPATH)/
	@cp $(SOURCE_DIR)/$(APP_PATH)/download_config/flash_download.txt $(OUTPATH)/
	# @$(OBJDUMP) -S $(OUTPATH)/$(PROJ_NAME)_xip.elf > $(OUTPATH)/$(PROJ_NAME)_xip.elf.s
	#@cp $(SOURCE_DIR)/driver/chip/mt7687/wifi_n9/WIFI_RAM_CODE_MT7687_in_flash.bin $(OUTPATH)/
	#@cp $(SOURCE_DIR)/driver/board/mt76x7_hdk/bootloader/loader_inflash.bin $(OUTPATH)/
	@$(SOURCE_DIR)/tools/scripts/build/copy_firmware.sh $(SOURCE_DIR) $(OUTPATH) $(IC_CONFIG) $(BOARD_CONFIG) $(PROJ_NAME)_xip.bin
	@cp *.cmm $(OUTPATH)/


MOD_EXTRA = BUILD_DIR=$(BUILD_DIR) OUTPATH=$(OUTPATH) PROJ_PATH=$(PROJ_PATH)

libs:
	make -C $(KRL_OS_PATH) $(MOD_EXTRA)
	make -C $(MID_TFTP_PATH) $(MOD_EXTRA)
	make -C $(MID_LWIP_PATH) $(MOD_EXTRA)
	make -C $(MID_CJSON_PATH) $(MOD_EXTRA)
	make -C $(MID_DHCPD_PATH) $(MOD_EXTRA)
	make -C $(MID_HTTPCLIENT_PATH) $(MOD_EXTRA)
	make -C $(MID_MBEDTLS_PATH) $(MOD_EXTRA)
	make -C $(MID_MQTT_PATH) $(MOD_EXTRA)
	make -C $(MID_NGHTTP2_PATH) $(MOD_EXTRA)
ifeq ($(MTK_NVRAM_ENABLE),y)
endif
	make -C $(MID_SMTCN_PATH) $(MOD_EXTRA)
	make -C $(MID_SNTP_PATH) $(MOD_EXTRA)
	make -C $(MID_XML_PATH) $(MOD_EXTRA)
	make -C $(MID_BSPEXT_PATH) $(MOD_EXTRA)
	make -C $(DRV_CHIP_PATH) $(MOD_EXTRA)
	make -C $(KRL_SRV_PATH) $(MOD_EXTRA)
	make -C $(DRV_BSP_PATH) $(MOD_EXTRA)
	make -C $(MID_PING_PATH) $(MOD_EXTRA)
	make -C $(MID_IPERF_PATH) $(MOD_EXTRA)
	make -C $(MID_FOTA_PATH) $(MOD_EXTRA)
ifeq ($(MTK_HOMEKIT_ENABLE),y)
	make -C $(MID_CURVE25519_PATH)  $(MOD_EXTRA)
	make -C $(MID_JSONC_PATH)  $(MOD_EXTRA)
	make -C $(MID_ED25519_PATH)  $(MOD_EXTRA)
	make -C $(MID_CHACHA20POLY1305_PATH)  $(MOD_EXTRA)
	make -C $(MID_SRP_PATH)  $(MOD_EXTRA)
endif


proj: $(OUTPATH)/$(PROJ_NAME)_xip.elf

$(OUTPATH)/$(PROJ_NAME)_xip.elf: $(C_OBJS) $(S_OBJS) $(LIBS)
	@echo Linking...
	@$(CC) $(LDFLAGS) -Wl,--start-group $^ -Wl,--end-group -Wl,-Map=$(OUTPATH)/$(PROJ_NAME)_xip.map -lm -o $@ 2>>$(ERR_LOG)
	@$(OBJCOPY) -O ihex $(OUTPATH)/$(PROJ_NAME)_xip.elf $(OUTPATH)/$(PROJ_NAME)_xip.hex
	@$(OBJCOPY) -O binary $(OUTPATH)/$(PROJ_NAME)_xip.elf $(OUTPATH)/$(PROJ_NAME)_xip.bin
	@echo Done

$(LIBS): libs

include $(SOURCE_DIR)/.rule.mk

clean:
	rm -rf $(OUTPATH)
	make -C $(MID_MINISUPP_PATH) $(MOD_EXTRA) clean

.PHONY: options

options:
	@for opt in `sed 's/[()]/\n/g' $(SOURCE_DIR)/config/chip/$(IC_CONFIG)/chip.mk|sed 's/-D/ /'|sort|uniq|grep ^MTK_|grep _ENABLE$$`; do echo $$opt; done
print-%  : ; @echo $* = $($*)
