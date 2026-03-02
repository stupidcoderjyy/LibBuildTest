# 预定义变量
# LIB_NAME
# LIB_VERSIONED_NAME
# LIB_SOURCE_DIR
# LIB_INSTALL_PREFIX

set(MAGE_ARGS
        INSTALL_PREFIX=${LIB_INSTALL_PREFIX}
        JOBS=16
)

# 构建和安装命令
set(LIB_CONFIGURE_COMMAND 
        # 不能设置为空
        echo "No configure step for SuiteSparse"
)

set(LIB_BUILD_COMMAND 
        make ${MAGE_ARGS}
)

set(LIB_INSTALL_COMMAND
        make install ${MAGE_ARGS}
)

# 依赖
set(LIB_DEPENDS
        ${NAME_OPENBLAS}
        ${NAME_GMP}
        ${NAME_MPFR}
)

set(OPENBLAS_LIB ${INSTALL_DIR}/${NAME_OPENBLAS}/lib)
set(GMP_ROOT ${INSTALL_DIR}/${NAME_GMP})
set(MPFR_ROOT ${INSTALL_DIR}/${NAME_MPFR})
set(ADDITIONAL_PATH 
        ${OPENBLAS_LIB}:${GMP_ROOT}:${MPFR_ROOT}
)

ExternalProject_Add(
        ${LIB_NAME}
        SOURCE_DIR ${LIB_SOURCE_DIR}
        BINARY_DIR ${LIB_SOURCE_DIR}
        CONFIGURE_COMMAND ${LIB_CONFIGURE_COMMAND}
        BUILD_COMMAND ${CMAKE_COMMAND}
                -E env PATH=${ADDITIONAL_PATH}:$ENV{PATH}
                ${LIB_BUILD_COMMAND}
        INSTALL_COMMAND ${LIB_INSTALL_COMMAND}
        LOG_CONFIGURE ON
        LOG_BUILD ON
        LOG_INSTALL ON
        DEPENDS ${LIB_DEPENDS}
)