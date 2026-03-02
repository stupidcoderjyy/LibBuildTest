# 预定义变量
# LIB_NAME
# LIB_VERSIONED_NAME
# LIB_SOURCE_DIR
# LIB_INSTALL_PREFIX

# 构建和安装命令
set(LIB_CONFIGURE_COMMAND 
        # 不能设置为空
        echo "No configure step for zstd"
)
set(LIB_BUILD_COMMAND 
        make -j16
)
set(LIB_INSTALL_COMMAND 
        make install PREFIX=${LIB_INSTALL_PREFIX}
)

# 依赖
set(LIB_DEPENDS "")

ExternalProject_Add(
        ${LIB_NAME}
        SOURCE_DIR ${LIB_SOURCE_DIR}
        BINARY_DIR ${LIB_SOURCE_DIR}
        CONFIGURE_COMMAND ${LIB_CONFIGURE_COMMAND}
        BUILD_COMMAND ${LIB_BUILD_COMMAND}
        INSTALL_COMMAND ${LIB_INSTALL_COMMAND}
        LOG_CONFIGURE ON
        LOG_BUILD ON
        LOG_INSTALL ON
        DEPENDS ${LIB_DEPENDS}
)