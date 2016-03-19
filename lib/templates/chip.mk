PRODUCT_VERSION=7687

# Default common setting
MTK_SYS_TRNG_ENABLE                         ?= y
MTK_MINISUPP_ENABLE                         ?= y
MTK_BSP_INBAND_NEW_ENABLE                   ?= y
MTK_NVRAM_ENABLE                            ?= y
MTK_LWIP_ENABLE                             ?= y
MTK_BSP_LOAD_WIFI_PROFILE_ENABLE            ?= y
MTK_WIFI_API_TEST_CLI_ENABLE                ?= y
MTK_HIF_GDMA_ENABLE                         ?= y
MTK_SUPPORT_APP_TEST_ENABLE                 ?= n
MTK_LWIP_DYNAMIC_DEBUG_ENABLE               ?= n
MTK_LWIP_STATISTICS_ENABLE                  ?= n
MTK_MAIN_CONSOLE_UART2_ENABLE               ?= n
MTK_BSP_LOOPBACK_ENABLE                     ?= n
MTK_OS_CPU_UTILIZATION_ENABLE               ?= n
MTK_SUPPORT_HEAP_DEBUG                      ?= n

CC      = $(BINPATH)/arm-none-eabi-gcc
AR      = $(BINPATH)/arm-none-eabi-ar
CXX     = $(BINPATH)/arm-none-eabi-g++
OBJCOPY = $(BINPATH)/arm-none-eabi-objcopy
SIZE    = $(BINPATH)/arm-none-eabi-size
OBJDUMP = $(BINPATH)/arm-none-eabi-objdump


ALLFLAGS = -Wall -mlittle-endian -mthumb -mcpu=cortex-m4
FPUFLAGS = -fsingle-precision-constant -Wdouble-promotion -mfpu=fpv4-sp-d16 -mfloat-abi=hard

#CFLAGS += $(ALLFLAGS) $(FPUFLAGS) -flto -ffunction-sections -fdata-sections -fno-builtin
CFLAGS += $(ALLFLAGS) $(FPUFLAGS) -ffunction-sections -fdata-sections -fno-builtin -Wimplicit-function-declaration
CFLAGS += -gdwarf-2 -Os -Wall -fno-strict-aliasing -fno-common
CFLAGS += -std=gnu99
CFLAGS += -DPCFG_OS=2 -D_REENT_SMALL
CFLAGS += -DPRODUCT_VERSION=$(PRODUCT_VERSION)


ifeq ($(MTK_SYS_TRNG_ENABLE),y)
CFLAGS         += -DMTK_SYS_TRNG_ENABLE
endif


ifeq ($(MTK_HEAP_GUARD_ENABLE),y)
ALLFLAGS       += -Wl,-wrap=pvPortMalloc -Wl,-wrap=vPortFree
CFLAGS         += -DHEAP_GUARD_ENABLE
endif

ifeq ($(MTK_CODE_COVERAGE_ENABLE),y)
CC = $(BINPATH)/arm-none-eabi-cov-gcc
CXX= $(BINPATH)/arm-none-eabi-cov-g++
AR = $(BINPATH)/arm-none-eabi-cov-ar
export GCOV_DIR=$(SOURCE_DIR)
endif

#
# MTK_MAIN_CONSOLE_UART2_ENABLE supports CM4 console output via UART2 (UART1
# in HW spec.) instead of UART1 (UART0 in HW spec). It needs the board circuit
# supports, and only applied in MTK EVB only so far. Default should be off.
#

ifeq ($(MTK_MAIN_CONSOLE_UART2_ENABLE),y)
CFLAGS         += -DMTK_MAIN_CONSOLE_UART2_ENABLE
endif

#
# MTK_NVDM_ENABLE decided if configuration system NVDM was supported or not.
# Default should be enabled.
#

ifeq ($(MTK_NVRAM_ENABLE),y)
CFLAGS         += -DMTK_NVRAM_ENABLE
endif

#
# MTK_WIFI_API_TEST_CLI_ENABLE contains test CLI commands used by RD, most of
# which are same as standard MTK CLI commands. Default should be disabled.
#
# OBSOLETE, to be removed soon
#

ifeq ($(MTK_WIFI_API_TEST_CLI_ENABLE),y)
CFLAGS          += -DMTK_WIFI_API_TEST_CLI_ENABLE
endif

#
# MTK_SUPPORT_APP_TEST_ENABLE enables the internet protocol test framework in
# sqc project, when enabled, cli commands that start with 'apptest', such as
# 'apptest http get http://<ip address / domain name>/' will be enabled.
#

ifeq ($(MTK_SUPPORT_APP_TEST_ENABLE),y)
CFLAGS          += -DMTK_SUPPORT_APP_TEST_ENABLE
endif

#
# MTK_MINISUPP_ENABLE enables built-in MTK mini-supplicant of CM4 version.
# All the security state machine and handshaking are processed by supplicant
# on CM4. Default should be enabled.
#

ifeq ($(MTK_MINISUPP_ENABLE),y)
CFLAGS         += -DMTK_MINISUPP_ENABLE
endif

#
# MTK_SMTCN_ENABLE enables built-in MTK smart connection.
# Default should be enabled.
#

ifeq ($(MTK_SMTCN_ENABLE),y)
CFLAGS         += -DMTK_SMTCN_ENABLE
endif

#
# MTK_MINICLI_ENABLE provides a tiny CLI engine as small as around 2.5KB.
# The description of API is in cli.h and plenty examples in cli_def.c.
#

ifeq ($(MTK_MINICLI_ENABLE),y)
LDFLAGS        += -lminicli
CFLAGS         += -DMTK_MINICLI_ENABLE
endif

#
# DEPRECATED (MTK mini-supplicant default support STA and SoftAP).
#

ifeq ($(MTK_WIFI_AP_ENABLE),y)
CFLAGS         += -DMTK_WIFI_AP_ENABLE
endif

#
# MTK_BSP_INBAND_NEW_ENABLE supports extension format of in-band-command for
# WiFi APIs due to original command field length isn't enough to support all
# the APIs. Default should be enabled.
#

ifeq ($(MTK_BSP_INBAND_NEW_ENABLE),y)
CFLAGS         += -DMTK_BSP_INBAND_NEW_ENABLE
endif

#
# MTK_BSP_LOAD_WIFI_PROFILE_ENABLE supports WiFi initial profile/configure
# download to N9 FW. The profile content comes from NVRAM. Default should be
# enabled.
#

ifeq ($(MTK_BSP_LOAD_WIFI_PROFILE_ENABLE),y)
CFLAGS         += -DMTK_BSP_LOAD_WIFI_PROFILE_ENABLE
endif

#
# MTK_PING_OUT_ENABLE supports MTK lite-ping tool to issue ping request
# toward the other peer of the connection. It's used by RD for debugging an
# default should be disabled.
#

ifeq ($(MTK_PING_OUT_ENABLE),y)
CFLAGS         += -DMTK_PING_OUT_ENABLE
endif

#
# MTK_IPERF_ENABLE supports iperf client and server service run on CM4. It
# supports almost all the major iPerf v2.0 features and most used for RD
# development and debug. Default should be disabled.
#

ifeq ($(MTK_IPERF_ENABLE),y)
CFLAGS         += -DMTK_IPERF_ENABLE
endif

#
# MTK_IPERF_DEBUG_ENABLE supports iperf client and server debug log and
# analysis functions used by RD. Default should be disabled.
#

ifeq ($(MTK_IPERF_DEBUG_ENABLE),y)
CFLAGS         += -DMTK_IPERF_DEBUG_ENABLE
endif

#
# MTK_BSPEXT_ENABLE supports all WIFI (BSP) related example codes, which
# demonstrate how to use WiFi (BSP) API and they're also invoked by WiFi CLI
# commands.
#

ifeq ($(MTK_BSPEXT_ENABLE),y)
CFLAGS         += -DMTK_BSPEXT_ENABLE
endif

#
# MTK_WIFI_TGN_VERIFY_ENABLE is an option to support TGn verification,
# which use large packet memory (64KB at SYSRAM) to pass TGn pass criteria.
# Once disable this flag, packet memory will shrink to 29KB and placed on TCM
# memory. This could release 64KB SYSRAM for customer use and speed up packet
# memory access.
#

ifeq ($(MTK_WIFI_TGN_VERIFY_ENABLE),y)
CFLAGS         += -DMTK_WIFI_TGN_VERIFY_ENABLE
endif

#
# This is for an early stage IC and hardware that has been delivered.
#
# DO NOT USE, if you do not know what this is.
#

ifeq ($(MT7687_E1), 1)
CFLAGS         += -D__EVB_E1__=1
endif

#
# DO NOT USE, software not available.
#

ifeq ($(IC_CONFIG),mt7687)
CFLAGS         += -DMTK_FOTA_ON_7687
endif

ifeq ($(MTK_FOTA_ENABLE), y)
CFLAGS         += -DMTK_FOTA_ENABLE
endif

#
# DO NOT USE, software not available.
#

ifeq ($(MTK_TFTP_ENABLE),y)
CFLAGS         += -DMTK_TFTP_ENABLE
endif

#
# MTK_HAL_PLAIN_LOG_ENABLE specifies the logging system used by HAL module.
# When enabled, plain printing (standard C library print) is supported. If
# not, HAL uses SYSLOG of MediaTek IoT SDK.
#

ifeq ($(MTK_HAL_PLAIN_LOG_ENABLE),y)
CFLAGS         += -DMTK_HAL_PLAIN_LOG_ENABLE
endif

#
# MTK_BSP_LOOPBACK_ENABLE supports WiFi throughput loopback test from CM4 to
# N9, without round trip to LMAC and the air. It's for RD internal development
# and debug. Default should be disabled.
#

ifeq ($(MTK_BSP_LOOPBACK_ENABLE),y)
CFLAGS         += -DMTK_BSP_LOOPBACK_ENABLE
endif

#
# MTK_OS_CPU_UTILIZATION_ENABLE supports the 'os 2' MTK CLI commands to
# show/get statistics of CM4 CPU utilizations of all the tasks running on.
#
# The code consumes some CPU cycles itself and default should be disabled.
#

ifeq ($(MTK_OS_CPU_UTILIZATION_ENABLE),y)
CFLAGS         += -DMTK_OS_CPU_UTILIZATION_ENABLE
endif

#
#MTK_SUPPORT_HEAP_DEBUG is a option to show heap status(alocatted or free),
#and will print debug info if any heap crash or heap use overflow, It's 
#for RD internal development and debug. Default should be disabled. 
#
ifeq ($(MTK_SUPPORT_HEAP_DEBUG),y)
CFLAGS         += -DMTK_SUPPORT_HEAP_DEBUG
endif

#
# MTK_HAL_LOWPOWER_ENABLE handles CM4 low power related interrupt and wakeup
# flow to protect CM4 from N9 sleep.
#

ifeq ($(MTK_HAL_LOWPOWER_ENABLE),y)
CFLAGS         += -DMTK_HAL_LOWPOWER_ENABLE
endif

#
# MTK_LWIP_ENABLE provide the LWIPs CLI for user.
#

ifeq ($(MTK_LWIP_ENABLE),y)
CFLAGS         += -DMTK_LWIP_ENABLE
endif

#
# MTK_LWIP_DYNAMIC_DEBUG_ENABLE provide debug information when its in running
# state. Default should be disabled.
#

ifeq ($(MTK_MINICLI_ENABLE),y)
ifeq ($(MTK_LWIP_DYNAMIC_DEBUG_ENABLE),y)
CFLAGS         += -DMTK_LWIP_DYNAMIC_DEBUG_ENABLE
endif
endif

#
# MTK_LWIP_STATISTICS_ENABLE provide the LWIP statistics collection. Such as
# memory usage. Packets sent and received.
#

ifeq ($(MTK_LWIP_STATISTICS_ENABLE),y)
CFLAGS         += -DMTK_LWIP_STATISTICS_ENABLE
endif

ifneq ($(MTK_MBEDTLS_CONFIG_FILE),)
CFLAGS         += -DMBEDTLS_CONFIG_FILE=\"$(MTK_MBEDTLS_CONFIG_FILE)\"
endif

ifeq ($(MTK_HOMEKIT_ENABLE),y)
CFLAGS += -DMTK_HOMEKIT_ENABLE
export HOMEKIT_DIR = middleware/protected/homekit
endif

ifeq ($(MTK_HIF_GDMA_ENABLE), y)
CFLAGS += -DMTK_HIF_GDMA_ENABLE
endif

ifeq ($(MTK_HCI_CONSOLE_MIX_ENABLE),y)
CFLAGS += -DMTK_HCI_CONSOLE_MIX_ENABLE
endif

ifeq ($(MTK_WIFI_FORCE_AUTOBA_DISABLE),y)
CFLAGS += -DMTK_WIFI_FORCE_AUTOBA_DISABLE
endif

ifeq ($(MTK_WIFI_WPS_ENABLE),y)
CFLAGS += -DMTK_WIFI_WPS_ENABLE
CONFIG_WPS=y
CONFIG_WPS2=y
endif

ifeq ($(MTK_WIFI_REPEATER_ENABLE),y)
CFLAGS += -DMTK_WIFI_REPEATER_ENABLE
CFLAGS += -DN9_DUAL_INF_READY
CONFIG_DUAL_INTERFACE=y
endif
ifeq ($(MTK_BLE_BQB_TEST_ENABLE),y)
CFLAGS += -DMTK_BLE_BQB_ENABLE
endif

ifeq ($(MTK_LOAD_MAC_ADDR_FROM_EFUSE),y)
CFLAGS += -DMTK_LOAD_MAC_ADDR_FROM_EFUSE
endif

#Incldue Path
CFLAGS += -I$(SOURCE_DIR)/kernel/rtos/FreeRTOS/inc
CFLAGS += -I$(SOURCE_DIR)/kernel/rtos/FreeRTOS/Source/include
CFLAGS += -I$(SOURCE_DIR)/driver/CMSIS/Device/MTK/mt7687/Include
CFLAGS += -I$(SOURCE_DIR)/driver/CMSIS/Include
CFLAGS += -I$(SOURCE_DIR)/driver/chip/mt7687/include
CFLAGS += -I$(SOURCE_DIR)/driver/chip/mt7687/inc
CFLAGS += -I$(SOURCE_DIR)/driver/chip/inc
CFLAGS += -I$(SOURCE_DIR)/driver/chip/mt7687/src/common/include
CFLAGS += -I$(SOURCE_DIR)/middleware/MTK/tftp/inc
CFLAGS += -I$(SOURCE_DIR)/middleware/MTK/fota/inc
CFLAGS += -I$(SOURCE_DIR)/middleware/MTK/fota/inc/76x7
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/cjson/inc
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/lwip/ports/include
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/lwip/src/include
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/lwip/src/include/lwip
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/dhcpd/inc
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/httpclient/inc
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/mbedtls/include
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/mbedtls/configs
CFLAGS += -I$(SOURCE_DIR)/middleware/MTK/minicli/inc
CFLAGS += -I$(SOURCE_DIR)/middleware/MTK/minisupp/inc
CFLAGS += -I$(SOURCE_DIR)/middleware/MTK/minisupp/include
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/mqtt/MQTTClient-C/src/mediatek
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/mqtt/MQTTClient-C/src
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/mqtt/MQTTPacket/src
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/nghttp2/lib/includes
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/nghttp2/lib/includes/nghttp2
ifeq ($(MTK_NVRAM_ENABLE),y)
CFLAGS += -I$(SOURCE_DIR)/middleware/MTK/nvram/inc
endif
CFLAGS += -I$(SOURCE_DIR)/middleware/MTK/smtcn/inc
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/sntp/inc
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/xml/inc
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/httpd/inc
CFLAGS += -I$(SOURCE_DIR)/middleware/MTK/iperf/inc
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/ping/inc
CFLAGS += -I$(SOURCE_DIR)/project/common/bsp_ex/inc
CFLAGS += -I$(SOURCE_DIR)/kernel/rtos/FreeRTOS/Source/portable/GCC/ARM_CM4F
CFLAGS += -I$(SOURCE_DIR)/kernel/service/inc
#Homekit & Security
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/curve25519/inc
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/jsonc/inc
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/ed25519/inc
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/chacha20poly1305/inc
CFLAGS += -I$(SOURCE_DIR)/middleware/third_party/srp/inc
CFLAGS += -I$(SOURCE_DIR)/$(HOMEKIT_DIR)/hkap/inc
CFLAGS += -I$(SOURCE_DIR)/$(HOMEKIT_DIR)/hkutil/inc
CFLAGS += -I$(SOURCE_DIR)/$(HOMEKIT_DIR)/mDNSResponder/inc
CFLAGS += -I$(SOURCE_DIR)/$(HOMEKIT_DIR)/hkdf/inc
CFLAGS += -I$(SOURCE_DIR)/$(HOMEKIT_DIR)/hap/inc
CFLAGS += -I$(SOURCE_DIR)/$(HOMEKIT_DIR)/hapua/inc
CFLAGS += -I$(SOURCE_DIR)/$(HOMEKIT_DIR)/wac/inc
CFLAGS += -I$(SOURCE_DIR)/$(HOMEKIT_DIR)/mfi/inc

#Middleware Module Path
MID_TFTP_PATH 		= $(SOURCE_DIR)/middleware/MTK/tftp
MID_FOTA_PATH 		= $(SOURCE_DIR)/middleware/MTK/fota
MID_LWIP_PATH 		= $(SOURCE_DIR)/middleware/third_party/lwip
MID_CJSON_PATH 		= $(SOURCE_DIR)/middleware/third_party/cjson
MID_DHCPD_PATH 		= $(SOURCE_DIR)/middleware/third_party/dhcpd
MID_HTTPCLIENT_PATH = $(SOURCE_DIR)/middleware/third_party/httpclient
MID_MBEDTLS_PATH 	= $(SOURCE_DIR)/middleware/third_party/mbedtls
MID_MINICLI_PATH 	= $(SOURCE_DIR)/middleware/MTK/minicli
MID_MINISUPP_PATH 	= $(SOURCE_DIR)/middleware/MTK/minisupp
MID_MQTT_PATH 		= $(SOURCE_DIR)/middleware/third_party/mqtt
MID_NGHTTP2_PATH 	= $(SOURCE_DIR)/middleware/third_party/nghttp2
ifeq ($(MTK_NVRAM_ENABLE),y)
MID_NVRAM_PATH      = $(SOURCE_DIR)/middleware/MTK/nvram
endif
MID_SMTCN_PATH 		= $(SOURCE_DIR)/middleware/MTK/smtcn
MID_SMTCN_CORE_PATH = $(SOURCE_DIR)/middleware/protected/smtcn
MID_SNTP_PATH 		= $(SOURCE_DIR)/middleware/third_party/sntp
MID_XML_PATH 		= $(SOURCE_DIR)/middleware/third_party/xml
MID_HTTPD_PATH 		= $(SOURCE_DIR)/middleware/third_party/httpd
MID_PING_PATH 		= $(SOURCE_DIR)/middleware/third_party/ping
MID_IPERF_PATH 		= $(SOURCE_DIR)/middleware/MTK/iperf
MID_BSPEXT_PATH		= $(SOURCE_DIR)/project/common/bsp_ex
DRV_CHIP_PATH 		= $(SOURCE_DIR)/driver/chip/mt7687
DRV_BSP_PATH 		= $(SOURCE_DIR)/driver/board/mt76x7_hdk
DRV_BSP_SEC_PATH 	= $(SOURCE_DIR)/driver/protected/board/mt76x7_hdk
KRL_OS_PATH 		= $(SOURCE_DIR)/kernel/rtos/FreeRTOS
KRL_SRV_PATH		= $(SOURCE_DIR)/kernel/service
KRL_SRV_CORE_PATH   = $(SOURCE_DIR)/kernel/service/src_core
KRL_SRV_PROTECTED_PATH  = $(SOURCE_DIR)/kernel/protected/service
#Homekit & Security
MID_HOMEKIT_PATH        =  $(SOURCE_DIR)/$(HOMEKIT_DIR)
MID_CURVE25519_PATH        =  $(SOURCE_DIR)/middleware/third_party/curve25519
MID_JSONC_PATH        =  $(SOURCE_DIR)/middleware/third_party/jsonc
MID_ED25519_PATH        =  $(SOURCE_DIR)/middleware/third_party/ed25519
MID_CHACHA20POLY1305_PATH        =  $(SOURCE_DIR)/middleware/third_party/chacha20poly1305
MID_SRP_PATH        =  $(SOURCE_DIR)/middleware/third_party/srp
