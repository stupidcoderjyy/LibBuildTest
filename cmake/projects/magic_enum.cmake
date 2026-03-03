# 预定义变量
# LIB_NAME
# LIB_VERSIONED_NAME
# LIB_SOURCE_DIR
# LIB_INSTALL_PREFIX

# 依赖
set(LIB_DEPENDS "")

ExternalProject_Add(
        ${LIB_NAME}
        SOURCE_DIR ${LIB_SOURCE_DIR}
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        # 先创建文件夹，然后复制头文件
        INSTALL_COMMAND sudo mkdir -p ${LIB_INSTALL_PREFIX}/include
        COMMAND sudo cp -r ${LIB_SOURCE_DIR}/include/magic_enum/. ${LIB_INSTALL_PREFIX}/include
        LOG_CONFIGURE ON
        LOG_BUILD ON
        LOG_INSTALL ON
        DEPENDS ${LIB_DEPENDS}
)