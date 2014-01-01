THEOS_DEVICE_IP = 192.168.1.247

TARGET = iphone:clang::7.0

include theos/makefiles/common.mk

export ARCHS = armv7 arm64

TWEAK_NAME = StatusBarFix2
StatusBarFix2_FILES = Tweak.xm
StatusBarFix2_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk


