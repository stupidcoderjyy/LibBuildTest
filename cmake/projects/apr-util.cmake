# 预定义变量
# LIB_NAME
# LIB_VERSIONED_NAME
# LIB_SOURCE_DIR
# LIB_INSTALL_PREFIX

# 构建和安装命令
set(LIB_CONFIGURE_COMMAND
        ${LIB_SOURCE_DIR}/configure
        # 安装到apr，而不是apr-util
        --prefix=${INSTALL_DIR}/${NAME_APR}
        # apr
        --with-apr=${INSTALL_DIR}/${NAME_APR}
)
set(LIB_BUILD_COMMAND make -j8)
set(LIB_INSTALL_COMMAND make install)

# 依赖
set(LIB_DEPENDS ${NAME_APR})

ExternalProject_Add(
        ${LIB_NAME}
        SOURCE_DIR ${LIB_SOURCE_DIR}
        BINARY_DIR ${LIB_SOURCE_DIR}/build
        CONFIGURE_COMMAND ${LIB_CONFIGURE_COMMAND}
        BUILD_COMMAND ${LIB_BUILD_COMMAND}
        INSTALL_COMMAND ${LIB_INSTALL_COMMAND}
        BUILD_ALWAYS OFF
        LOG_CONFIGURE ON
        LOG_BUILD ON
        LOG_INSTALL ON
        DEPENDS ${LIB_DEPENDS}
)