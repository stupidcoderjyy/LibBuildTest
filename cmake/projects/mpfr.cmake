# 预定义变量
# LIB_NAME
# LIB_VERSIONED_NAME
# LIB_SOURCE_DIR
# LIB_INSTALL_PREFIX

# 构建和安装命令
set(LIB_CONFIGURE_COMMAND
        ${LIB_SOURCE_DIR}/configure
        --prefix=${LIB_INSTALL_PREFIX}
        --with-gmp=${INSTALL_DIR}/${NAME_GMP}
)

set(LIB_BUILD_COMMAND 
        make -j16
)
set(LIB_INSTALL_COMMAND 
        make install
)

# 依赖
set(LIB_DEPENDS 
    ${NAME_GMP}
    ${NAME_AUTOMAKE}
)

set(AUTOMAKE ${INSTALL_DIR}/${NAME_AUTOMAKE}/bin)

ExternalProject_Add(
        ${LIB_NAME}
        SOURCE_DIR ${LIB_SOURCE_DIR}
        BINARY_DIR ${LIB_SOURCE_DIR}
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env
                PATH=/usr/local/bin:$ENV{PATH}
                ${LIB_CONFIGURE_COMMAND}
        BUILD_COMMAND ${CMAKE_COMMAND} -E env
                PATH=${AUTOMAKE}:$ENV{PATH}
                ${LIB_BUILD_COMMAND}
        INSTALL_COMMAND ${LIB_INSTALL_COMMAND}
        LOG_CONFIGURE ON
        LOG_BUILD ON
        LOG_INSTALL ON
        DEPENDS ${LIB_DEPENDS}
)