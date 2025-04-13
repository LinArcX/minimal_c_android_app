LIB="libtest"
SOURCES="main"
SRC_DIR="src"
OUTPUT_DIR="output"

PLATFORMS="30"
AND_SDK="/mnt/D/software/android_sdk"
AND_NDK="$AND_SDK/ndk/25.2.9519653"
BUILD_TOOLS="$AND_SDK/build-tools/30.0.3"

HOST="linux"
HOST_ARCH="x86_64"
HOST_COMPILER="clang"

TARGET="android"
TARGET_ARCH="x86_64"
AARCH64_LINUX_ANDROID30_CLANG="toolchains/llvm/prebuilt/$HOST-$HOST_ARCH/bin/$TARGET_ARCH-$HOST-$TARGET$PLATFORMS-$HOST_COMPILER"
TARGET_COMPILER="$AND_NDK/$AARCH64_LINUX_ANDROID30_CLANG"

TG="$TARGET_ARCH-$HOST-$TARGET$PLATFORMS"

INC_NATIVE_APP_GLUE="$AND_NDK/sources/android/native_app_glue"
INC_NATIVE_APP_GLUE_C="$AND_NDK/sources/android/native_app_glue/android_native_glue_app.c"
INC_SYSROOT_INCLUDE="$AND_NDK/sysroot/usr/include"
INC_SYSROOT_ANDROID_INCLUDE="$AND_NDK/sysroot/usr/include/include"

LNK_SYSROOT_LIB="$AND_NDK/toolchains/llvm/prebuilt/$HOST-$HOST_ARCH/sysroot/usr/lib/$TARGET_ARCH-$HOST-$TARGET$PLATFORMS"
LNK_GENERAL="-landroid -llog"

# check if $OUTPUT_DIR exists, otherwise create it
mkdir -p $OUTPUT_DIR/$TARGET_ARCH

# compile $SOURCES to $SOURCES.o
$TARGET_COMPILER -c $SRC_DIR/$SOURCES.c -I$INC_NATIVE_APP_GLUE -I$INC_SYSROOT_INCLUDE -I$INC_SYSROOT_ANDROID_INCLUDE -o $OUTPUT_DIR/$TARGET_ARCH/$SOURCES.o -target $TG -fPIC

# compile $SOURCES.o to $LIB
$TARGET_COMPILER -shared $OUTPUT_DIR/$TARGET_ARCH/$SOURCES.o -I$INC_NATIVE_APP_GLUE_C -L$LNK_SYSROOT_LIB $LNK_GENERAL -o $OUTPUT_DIR/$TARGET_ARCH/$LIB.so -target $TG

# compile resources
$BUILD_TOOLS/aapt2 compile res/mipmap/ic_launcher.png -o $OUTPUT_DIR/$TARGET_ARCH/compiled_resources
unzip ./$OUTPUT_DIR/$TARGET_ARCH/compiled_resources -d ./$OUTPUT_DIR/$TARGET_ARCH
$BUILD_TOOLS/aapt2 link -o $OUTPUT_DIR/$TARGET_ARCH/unsigned.apk --manifest AndroidManifest.xml -I $AND_SDK/platforms/android-30/android.jar $OUTPUT_DIR/$TARGET_ARCH/*.flat 
