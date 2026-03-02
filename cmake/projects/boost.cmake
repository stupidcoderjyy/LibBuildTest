# 预定义变量
# LIB_NAME
# LIB_VERSIONED_NAME
# LIB_SOURCE_DIR
# LIB_INSTALL_PREFIX

# 构建和安装命令
set(LIB_CONFIGURE_COMMAND
        ${LIB_SOURCE_DIR}/bootstrap.sh
        --prefix=${LIB_INSTALL_PREFIX}
)
set(LIB_BUILD_COMMAND 
        ${LIB_SOURCE_DIR}/b2 -j16
        pch=off
        link=shared
        threading=multi
        runtime-link=shared
        install
)
set(LIB_INSTALL_COMMAND 
        # 安装命令已包含在构建命令中
        echo "Boost安装完成"
)

set(ZSTD ${INSTALL_DIR}/${NAME_ZSTD})

# 依赖
set(LIB_DEPENDS ${NAME_ZSTD})

ExternalProject_Add(
        ${LIB_NAME}
        SOURCE_DIR ${LIB_SOURCE_DIR}
        BINARY_DIR ${LIB_SOURCE_DIR}
        CONFIGURE_COMMAND ${LIB_CONFIGURE_COMMAND}
        BUILD_COMMAND ${CMAKE_COMMAND}
                -E env PATH=${ZSTD}:$ENV{PATH}
                ${LIB_BUILD_COMMAND}
        INSTALL_COMMAND ${LIB_INSTALL_COMMAND}
        LOG_CONFIGURE ON
        LOG_BUILD ON
        LOG_INSTALL ON
        DEPENDS ${LIB_DEPENDS}
)