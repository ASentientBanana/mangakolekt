#!/usr/bin/env bash

# armeabi-v7a: For devices with ARMv7 processors.
# arm64-v8a: For devices with ARMv8 (64-bit) processors.
# x86: For devices with x86 processors.
# x86_64: 

# amd64: 64-bit x86 (the most mature port)
# 386: 32-bit x86
# arm: 32-bit ARM
# arm64: 64-bit ARM


# Declare an associative array
declare -A architectures
declare -A armArchitectures

MANGA_LIB=manga_archive.so
ARM_COMPILER="/usr/bin/aarch64-linux-gnu-gcc"

# List of supported architectures
# x86
architectures["amd64"]="x86_64"
architectures["386"]="x86"
# ARM
architectures["arm"]="armeabi-v7a"
architectures["arm64"]="arm64-v8a"

verify(){
    path=$1
    arch=$2
    if ! test -f $path; then
        echo "Problem compiling file for $arch. No output was found in $path"
    fi
}

compile(){
    arch=$1
    BUILD_TARGET="./build/linux/$arch/$MANGA_LIB"

    echo "Compliing for $arch"
    if [ "$arch" = "amd64" ]; then
    CGO_ENABLED=1 GOOS="linux" GOARCH="$arch" go build -buildmode=c-shared -o "$BUILD_TARGET" "main.go"
    rm "$PROJECT_ROOT/lib/linux/$MANGA_LIB"
    cp $BUILD_TARGET "$PROJECT_ROOT/lib/linux/$MANGA_LIB"
    elif [ "$arch" = "386" ]; then
    CGO_ENABLED=1 GOOS="linux" GOARCH="$arch" go build -buildmode=c-shared -o "$BUILD_TARGET" "main.go"
    elif [ "$arch" = "arm64" ]; then
    cc=/home/petar/Android/Sdk/ndk/23.1.7779620/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android30-clang
    CC=$cc CGO_ENABLED=1 GOOS="android" GOARCH="$arch" go build -buildmode=c-shared -o "$BUILD_TARGET" "main.go"
    elif [ "$arch" = "arm" ]; then
    cc=/home/petar/Android/Sdk/ndk/23.1.7779620/toolchains/llvm/prebuilt/linux-x86_64/bin/armv7a-linux-androideabi30-clang
    CC=$cc CGO_ENABLED=1 GOOS="android" GOARCH="$arch" go build -buildmode=c-shared -o "$BUILD_TARGET" "main.go"
    # CC="musl-gcc -static" CGO_ENABLED=1 GOOS="linux" GOARCH="$arch" go build -buildmode=c-shared -o "$BUILD_TARGET" "main.go"
    else
    echo "Architecture is not ARM64"
    # Your code for other architectures goes here
    fi
    mkdir -p build/linux/$arch

    ANDROID_TARGET="$PROJECT_ROOT/android/app/src/main/jniLibs/${architectures["$arch"]}/$MANGA_LIB"
    echo "Coping output file to: $BUILD_TARGET"
    cp $BUILD_TARGET $ANDROID_TARGET
}

PROJECT_ROOT="$(pwd)"
rm -rf dist/linux
mkdir -p ./dist/linux
cd unzip/
rm -rf build/linux
# Run compilers for the different platforms
echo "Starting compilation process"
for key in "${!architectures[@]}"; do
    compile $key
done


cd $PROJECT_ROOT
# flutter build linux --release
# cp -r build/linux/x64/release/bundle/. $PROJECT_ROOT/dist/linux/.
# cp -r ./unzip/build/linux/amd64/. $PROJECT_ROOT/dist/linux/lib/.

#generate tarball
# tar -czvf mangakolekt.tar.gz ./dist/linux/
# mv $PROJECT_ROOT/mangakolekt.tar.gz $PROJECT_ROOT/dist/linux