LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua

LOCAL_SRC_FILES := \
../../../Classes/AppDelegate.cpp \
../../../Classes/buyu1/FishFactory.cpp \
../../../Classes/buyu1/math_aide.cpp \
../../../Classes/buyu1/scene_fish_trace.cpp \
../../../Classes/buyu1/scene_fish_trace2.cpp \
../../../Classes/luabind/lua_cocos2d_ex.cpp \
../../../Classes/md5/md5.c \
../../../Classes/network/clientSock.cpp \
../../../Classes/network/IconvString.cpp \
../../../Classes/network/lock.cpp \
../../../Classes/network/MapCoding.cpp \
../../../Classes/network/recvBuff.cpp \
../../../Classes/network/sendBuff.cpp \
../../../Classes/qrcode/bitstream.c \
../../../Classes/qrcode/mask.c \
../../../Classes/qrcode/qrencode.c \
../../../Classes/qrcode/qrinput.c \
../../../Classes/qrcode/qrspec.c \
../../../Classes/qrcode/rscode.c \
../../../Classes/qrcode/split.c \
hellolua/main.cpp

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../Classes \
$(LOCAL_PATH)/../../../Classes/buyu1 \
$(LOCAL_PATH)/../../../Classes/luabind \
$(LOCAL_PATH)/../../../Classes/md5 \
$(LOCAL_PATH)/../../../Classes/network \
$(LOCAL_PATH)/../../../Classes/qrcode

# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cclua_static

# _COCOS_LIB_ANDROID_BEGIN
# _COCOS_LIB_ANDROID_END

include $(BUILD_SHARED_LIBRARY)

$(call import-module, cocos/scripting/lua-bindings/proj.android)

# _COCOS_LIB_IMPORT_ANDROID_BEGIN
# _COCOS_LIB_IMPORT_ANDROID_END
