#!/bin/bash
rm -rf /out
make kernelversion
export ARCH=arm64 && export SUBARCH=arm64 malakas_beryllium_defconfig
#/scripts/config -e CLANG_LTO
#make ARCH=arm64 oldconfig
export CROSS_COMPILE=~/TOOLCHAIN/gcc/bin/aarch64-elf-
#export CC=~/TOOLCHAIN/dtc/bin/clang 
#export CLANG_TRIPLE=~/TOOLCHAIN/gcc/bin/aarch64-linux-gnu-
export LD=~/TOOLCHAIN/clang/bin/ld.lld
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache
mkdir -p out
make O=out clean
make O=out malakas_beryllium_defconfig
make -j$(nproc --all) O=out 
mv out/arch/arm64/boot/Image.gz-dtb ~/TOOLCHAIN/AK2TEST/Image.gz-dtb
rm -rf out
cd ~/TOOLCHAIN/AK2TEST
zip -r MLX_TEST65hz_$(date +"%Y-%m-%d").zip *
rm -rf Image.gz-dtb
mv MLX_TEST65hz-$(date +"%Y-%m-%d").zip ~/Desktop/MLX/
cd ~/Desktop/MLX/
adb kill-server
adb tcpip 5555
adb connect 192.168.3.101:5555
sleep 2
adb push MLX_TEST65hz_$(date +"%Y-%m-%d").zip /sdcard/...test.../MLX_TEST65hz_$(date +"%Y-%m-%d").zip
adb reboot recovery


