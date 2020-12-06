# We need static libtruetype but it isn't in standard android makefile :(
# this is now the default FreeType build for Android
#
LOCAL_PATH := external/freetype
include $(CLEAR_VARS)

# compile in ARM mode, since the glyph loader/renderer is a hotspot
# when loading complex pages in the browser
#
LOCAL_ARM_MODE := arm

LOCAL_SRC_FILES:= \
    src/base/ftbbox.c \
    src/base/ftbitmap.c \
    src/base/ftfstype.c \
    src/base/ftglyph.c \
    src/base/ftlcdfil.c \
    src/base/ftstroke.c \
    src/base/fttype1.c \
    src/base/ftbase.c \
    src/base/ftsystem.c \
    src/base/ftinit.c \
    src/base/ftgasp.c \
    src/raster/raster.c \
    src/sfnt/sfnt.c \
    src/smooth/smooth.c \
    src/autofit/autofit.c \
    src/truetype/truetype.c \
    src/cff/cff.c \
    src/psnames/psnames.c \
    src/pshinter/pshinter.c \
    src/psaux/psaux.c

ifeq ($(shell if [ -e "external/freetype/src/gzip/ftgzip.c" ]; then echo "hasgzip"; fi),hasgzip)
LOCAL_SRC_FILES += src/gzip/ftgzip.c
endif

ifeq ($(shell if [ -e "external/freetype/src/base/ftxf86.c" ]; then echo "found"; fi),found)
LOCAL_SRC_FILES += src/base/ftxf86.c
else
LOCAL_SRC_FILES += \
    src/base/ftfntfmt.c \
    src/base/ftmm.c
endif

ifeq ($(shell if [ -e "external/freetype/src/type1/type1.c" ]; then echo "hastype1"; fi),hastype1)
LOCAL_SRC_FILES += \
    src/type1/type1.c \
    src/cid/type1cid.c
endif

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/builds \
    $(LOCAL_PATH)/include \
    external/libpng \
    external/zlib

LOCAL_CFLAGS += -W \
    -Wall \
    -fPIC \
    -DPIC \
    -DDARWIN_NO_CARBON \
    -DFT2_BUILD_LIBRARY \
    -O2 \
    -Wno-unused-parameter \
    -Wno-unused-variable

LOCAL_STATIC_LIBRARIES += libpng libz

# the following is for testing only, and should not be used in final builds
# of the product
#LOCAL_CFLAGS += "-DTT_CONFIG_OPTION_BYTECODE_INTERPRETER"

LOCAL_MODULE:= libft2_mrom_static

include $(BUILD_STATIC_LIBRARY)
