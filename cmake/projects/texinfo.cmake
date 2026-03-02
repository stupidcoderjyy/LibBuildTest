# 预定义变量
# LIB_NAME
# LIB_VERSIONED_NAME
# LIB_SOURCE_DIR
# LIB_INSTALL_PREFIX
# 设置项
# LIB_IS_ROOT 项目是否为根项目，默认为TRUE

# 非根项目
set(LIB_IS_ROOT FALSE)

# 构建和安装命令
set(LIB_CONFIGURE_COMMAND
        # 必须加sudo，否则编译失败
        sudo ${LIB_SOURCE_DIR}/configure
        --prefix=${LIB_INSTALL_PREFIX}
)
set(LIB_BUILD_COMMAND 
        sudo make -j16
)
set(LIB_INSTALL_COMMAND 
        sudo make install
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