export ARCHS = arm64 arm64e
export DEBUG = 1
export FINALPACKAGE = 1

export PREFIX = $(THEOS)/toolchain/Xcode11.xctoolchain/usr/bin/

TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = MobileSafari


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SafariTabs14

SafariTabs14_FILES = $(wildcard *.x)
SafariTabs14_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
