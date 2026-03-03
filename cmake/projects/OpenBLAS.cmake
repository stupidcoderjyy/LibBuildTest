# 预定义变量
# LIB_NAME
# LIB_VERSIONED_NAME
# LIB_SOURCE_DIR
# LIB_INSTALL_PREFIX

# 确认CPU架构
include(${CONFIG_DIR}/${LIB_NAME}/cpu_arch.cmake)
message(STATUS "OpenBLAS TARGET: ${OPENBLAS_TARGET}")

# 查找Fortran编译器
enable_language(Fortran)
get_filename_component(GFORTRAN_EXECUTABLE ${CMAKE_Fortran_COMPILER} ABSOLUTE)
message(STATUS "Found Fortran compiler: ${GFORTRAN_EXECUTABLE}")

# 查找libgfortran库路径
include(${CONFIG_DIR}/${LIB_NAME}/find_gfortranlib.cmake)
message(STATUS "found libgfortran.so: ${GFORTRAN_LIB_PATH}")
get_filename_component(GFORTRAN_LIB_DIR ${GFORTRAN_LIB_PATH} DIRECTORY)

# 检查CPU是否支持AVX2
include(${CONFIG_DIR}/${LIB_NAME}/check_avx2.cmake)
set(NO_AVX2 ${AVX2_NOT_SUPPORTED})

# 检查CPU是否支持AVX512
include(${CONFIG_DIR}/${LIB_NAME}/check_avx512.cmake)
set(NO_AVX512 ${AVX512_NOT_SUPPORTED})

# 带空格参数
set(COMMON_OPT "-O3 -g -fPIC")
set(FCOMMON_OPT "-O3 -g -fPIC -frecursive")
set(LD_FLAGS "-L${INSTALL_DIR}/${NAME_ISL}/lib -L${GFORTRAN_LIB_DIR}")

set(MAKE_ARGS
        TARGET=${OPENBLAS_TARGET}
        DYNAMIC_ARCH=0  # 强制使用上面得到的CPU架构
        DYNAMIC_OLDER=1
        # 线程与并行
        USE_THREAD=0
        USE_OPENMP=0
        # 编译器指定（双下划线表示引号）
        FC=__${GFORTRAN_EXECUTABLE}__
        CC=__${CMAKE_C_COMPILER}__
        # 编译优化选项
        COMMON_OPT=__${COMMON_OPT}__
        FCOMMON_OPT=__${FCOMMON_OPT}__
        # 线程数与库命名
        NMAX=__NUM_THREADS=128__
        LIBPREFIX=__libopenblas__
        # 功能开关
        NO_LAPACKE=1
        INTERFACE64=0
        NO_STATIC=1
        NO_AVX2=${AVX2_NOT_SUPPORTED}
        NO_AVX512=${AVX512_NOT_SUPPORTED}
        # 安装路径
        PREFIX=${LIB_INSTALL_PREFIX}
        # 链接选项
        LDFLAGS=__${LD_FLAGS}__
)

# 构建命令
set(BUILD_CMD
        sudo make ${MAKE_ARGS}
)

# 由于cmake ExternalProject_Add不支持带引号的参数传递，故将命令写入脚本文件
set(BUILD_SCRIPT "${CMAKE_SOURCE_DIR}/build/BuildOpenBLAS.sh")
string(REPLACE ";" " " BUILD_CMD_STR "${BUILD_CMD}")
string(REPLACE "__" "\"" BUILD_CMD_STR "${BUILD_CMD_STR}")
configure_file(
    ${CONFIG_DIR}/OpenBLAS/BuildOpenBLAS.sh.in  # 模板文件路径
    ${BUILD_SCRIPT}                             # 输出文件路径
    @ONLY                                       # 仅替换 @变量名@ 格式
    NEWLINE_STYLE UNIX                          # 强制 LF 换行
)

# 构建命令
set(LIB_BUILD_COMMAND
        sudo ${BUILD_SCRIPT}
)

# 依赖
set(LIB_DEPENDS ${NAME_ISL})

ExternalProject_Add(
        ${LIB_NAME}
        SOURCE_DIR ${LIB_SOURCE_DIR}
        BINARY_DIR ${LIB_SOURCE_DIR}/build
        CONFIGURE_COMMAND ""
        BUILD_COMMAND chmod +x ${BUILD_SCRIPT}
        COMMAND sudo ${LIB_BUILD_COMMAND}
        INSTALL_COMMAND ""
        LOG_CONFIGURE ON
        LOG_BUILD ON
        LOG_INSTALL ON
        DEPENDS ${LIB_DEPENDS}
)