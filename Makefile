TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = Music

ARCHS = arm64 arm64e
SYSROOT = $(THEOS)/sdks/iPhoneOS14.2.sdk
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MusicAlert

MusicAlert_FILES = Tweak.xm
MusicAlert_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
