LIB="libtest"
SOURCES="main"
SRC_DIR="src"
OUTPUT_DIR="build"

PLATFORMS="30"
AND_SDK="/mnt/D/software/android_sdk"
AND_NDK="$AND_SDK/ndk/25.2.9519653"

HOST="linux"
HOST_ARCH="x86_64"
HOST_COMPILER="clang"

TARGET="android"
TARGET_ARCH="aarch64"
AARCH64_LINUX_ANDROID30_CLANG="toolchains/llvm/prebuilt/$HOST-$HOST_ARCH/bin/$TARGET_ARCH-$HOST-$TARGET$PLATFORMS-$HOST_COMPILER"
TARGET_COMPILER="$AND_NDK/$AARCH64_LINUX_ANDROID30_CLANG"

TG="$TARGET_ARCH-$HOST-$TARGET$PLATFORMS"

INC_NATIVE_APP_GLUE="$AND_NDK/sources/android/native_app_glue"
INC_NATIVE_APP_GLUE_C="$AND_NDK/sources/android/native_app_glue/android_native_glue_app.c"
INC_SYSROOT_INCLUDE="$AND_NDK/sysroot/usr/include"
INC_SYSROOT_ANDROID_INCLUDE="$AND_NDK/sysroot/usr/include/include"

LNK_SYSROOT_LIB="$AND_NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/aarch64-linux-android30"
LNK_GENERAL="-landroid -llog"

# check if $OUTPUT_DIR exists, otherwise create it
mkdir -p $OUTPUT_DIR

#arm64-v8a
#armeabi-v7a
#x86_64/

# compile $SOURCES to $SOURCES.o
$TARGET_COMPILER -c $SRC_DIR/$SOURCES.c -I$INC_NATIVE_APP_GLUE -I$INC_SYSROOT_INCLUDE -I$INC_SYSROOT_ANDROID_INCLUDE -o $OUTPUT_DIR/$SOURCES.o -target $TG -fPIC

# compile $SOURCES.o to $LIB
$TARGET_COMPILER -shared $OUTPUT_DIR/$SOURCES.o -I$INC_NATIVE_APP_GLUE_C -L$LNK_SYSROOT_LIB $LNK_GENERAL -o $OUTPUT_DIR/$LIB.so -target $TG
