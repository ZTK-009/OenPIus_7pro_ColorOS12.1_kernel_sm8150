#! /bin/bash 
echo "######KernelSU的一键补丁脚本，可重复执行，获得最新KernelSU版本######"
echo "           "
echo "######使用方法修改export KD=vendor/xxxx_defconfig或当前终端直接 export KD=xxxxx_defconfig或export KD=vendor/xxxxx_defconfig，xxxxx_defconfig为你机型的内核配置并运行此脚本，然后按一般方式构建内核######"
echo "           "
echo "脚本为国内加速构建脚本，没上网条件首选KSU-patch1.sh"


export KD=sm8150-perf_defconfig

#手机的内核配置文件，一般在内核源码目录下的arch/arm64/configs或arch/arm64/configs/vendor下，一般为机型代号，高通骁龙处理器代号啥的，比如mi5 的为gemini_defconfig,一加8系列为kona_pref_defconfig,按实际情况修改
#export KD=gemini_defconfig 
#KD=vendor/xxxx_defconfig或KD=xxxx_defconfig

echo " -----------------------------------------------------------------------------"
echo "----------------   你设置的内核配置文件为:$KD   ----------------"
echo " -----------------------------------------------------------------------------"


#env
export GKI_ROOT=$(pwd)
export ARCH=arm64
export SUBARCH=arm64
rm -rf $GKI_ROOT/KernelSU $GKI_ROOT/drivers/kernelsu




echo "         "
echo "#添加KernelSU,到内核树"
echo "         "
# Add KernelSU to kernel tree
#以下链接任选其一，默认是https://github.com/tiann/KernelSU，一个不行换另一个即可，取消注释即可，切勿滥用。当然有魔法直接突破。
git clone https://github.com/tiann/KernelSU.git 
#git clone -b main https://gitee.com/mirrors/KernelSU.git KernelSU
#git clone https://kgithub.com/tiann/KernelSU.git
#git clone https://github.moeyy.xyz/https://github.com/tiann/KernelSU.git
#git clone https://gitclone.com/github.com/tiann/KernelSU.git
#git clone https://ghproxy.com/https://github.com/tiann/KernelSU.git
#git clone https://hub.njuu.cf/tiann/KernelSU.git
#git clone https://hub.yzuu.cf/tiann/KernelSU.git

#sleep 2m

DRIVER_DIR="$GKI_ROOT/drivers"
DRIVER_MAKEFILE=$DRIVER_DIR/Makefile
ln -sf "$GKI_ROOT/KernelSU/kernel" "$DRIVER_DIR/kernelsu"
#echo "obj-y += kernelsu/" >>"$DRIVER_MAKEFILE"
sed -i '$a\obj-y += kernelsu/' "$DRIVER_MAKEFILE"

#添加KernelSU内核配置，当然已经在内核源内运行过一遍，可将此5项注释掉，多次执行也没问题指不过会在 dervierMarkfile,KERNEL_DEFCONFIG}_defcofig引入过多重复，无影响。。。。
echo "CONFIG_KPROBES=y" >> "$GKI_ROOT/arch/arm64/configs/${KD}"
echo "CONFIG_HAVE_KPROBES=y" >> "$GKI_ROOT/arch/arm64/configs/${KD}"
echo "CONFIG_KPROBE_EVENTS=y" >> "$GKI_ROOT/arch/arm64/configs/${KD}"
#下面2项，按情况选择吧。
echo "CONFIG_OVERLAY_FS=y" >> "$GKI_ROOT/arch/arm64/configs/${KD}"
echo "CONFIG_MODULES=y" >> "$GKI_ROOT/arch/arm64/configs/${KD}"

echo "           "
echo "KernelSU补丁完成，请按一般方式构建内核"
echo "           "

