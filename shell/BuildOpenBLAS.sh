# 本脚本自动生成，见./cmake/projects/OpenBLAS.cmake
cd /mnt/c/Users/baojunyingjie/LibBuildTest/libsrc/OpenBLAS-0.3.29
if ! sudo make TARGET=CORE2 DYNAMIC_ARCH=0 DYNAMIC_OLDER=1 USE_THREAD=0 USE_OPENMP=0 FC="/usr/bin/gfortran" CC="gcc" COMMON_OPT="-O3 -g -fPIC" FCOMMON_OPT="-O3 -g -fPIC -frecursive" NMAX="NUM_THREADS=128" LIBPREFIX="libopenblas" NO_LAPACKE=1 INTERFACE64=0 NO_STATIC=1 NO_AVX2=0 NO_AVX512=1 PREFIX=/mnt/c/Users/baojunyingjie/LibBuildTest/out/OpenBLAS LDFLAGS="-L/mnt/c/Users/baojunyingjie/LibBuildTest/out/isl/lib -L/usr/lib/gcc/x86_64-linux-gnu/13"; then
    echo "Build failed"
    exit 1
fi
echo "=====Installing OpenBLAS====="
sudo make TARGET=CORE2 DYNAMIC_ARCH=0 DYNAMIC_OLDER=1 USE_THREAD=0 USE_OPENMP=0 FC="/usr/bin/gfortran" CC="gcc" COMMON_OPT="-O3 -g -fPIC" FCOMMON_OPT="-O3 -g -fPIC -frecursive" NMAX="NUM_THREADS=128" LIBPREFIX="libopenblas" NO_LAPACKE=1 INTERFACE64=0 NO_STATIC=1 NO_AVX2=0 NO_AVX512=1 PREFIX=/mnt/c/Users/baojunyingjie/LibBuildTest/out/OpenBLAS LDFLAGS="-L/mnt/c/Users/baojunyingjie/LibBuildTest/out/isl/lib -L/usr/lib/gcc/x86_64-linux-gnu/13" install
