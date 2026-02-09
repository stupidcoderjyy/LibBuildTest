# 自定义项目
set(LIB_PROJECT_TYPE "log4cxx")

set(PKG_CONFIG_EXECUTABLE ${LIB_INSTALL_PREFIX}/${NAME_PKG_CONFIG}/bin/pkg-config)
set(APR_OUT_PATH ${LIB_INSTALL_PREFIX}/${NAME_APR})
set(PKG_CONFIG_PATH ${LIB_INSTALL_PREFIX}/${NAME_APR}/lib/pkgconfig)

set(LIB_CMAKE_ARGS
        # 默认选项
        ${LIB_CMAKE_ARGS}
        # 不编译测试代码
        -DBUILD_TESTING=off
        # 项目依赖（apr和apr-util）
#        -DAPR_INCLUDE_DIR=${APR_OUT_PATH}/include/apr-1
#        -DAPR_LIBRARIES=${APR_OUT_PATH}/lib/libapr-1.a
#        -DAPR_UTIL_INCLUDE_DIR=${APR_OUT_PATH}include/apr-1
#        -DAPR_UTIL_LIBRARIES=${APR_OUT_PATH}/lib/libaprutil-1.a
        -DPKG_CONFIG_EXECUTABLE=${PKG_CONFIG_EXECUTABLE}
)

# 依赖
set(LIB_DEPENDS
        ${NAME_PKG_CONFIG}
        ${NAME_APR}
        ${NAME_APR_UTIL}
)