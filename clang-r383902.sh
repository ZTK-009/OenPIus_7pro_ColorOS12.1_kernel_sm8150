#!/bin/bash

# 设置环境变量
export CCACHE_COMPILERCHECK="%compiler% -dumpmachine; %compiler% -dumpversion"
export CCACHE_NOHASHDIR="true"
export CCACHE_MAXSIZE="4G"
export CCACHE_HARDLINK="true"
export KERNEL_DEFCONFIG="sm8150-perf_defconfig"
export KERNEL_CMDLINE="ARCH=arm64 CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=aarch64-linux-androidkernel- CROSS_COMPILE_ARM32=arm-linux-gnueabi- LLVM=1 LLVM_IAS=1 O=out"
# 构建内核
export PATH=/root/clang/bin:/root/aarch64/bin:$PATH
export ARCH=arm64
export SUBARCH=arm64
export LD=ld.lld
export BRAND_SHOW_FLAG=oneplus
export TARGET_PRODUCT=msmnile
make mrproper 
make $KERNEL_CMDLINE $KERNEL_DEFCONFIG CC="ccache clang"
make $KERNEL_CMDLINE CC="ccache clang" -j$(nproc --all)
# 安装内核模块  
make $KERNEL_CMDLINE INSTALL_MOD_PATH="out" INSTALL_MOD_STRIP=1 modules_install

