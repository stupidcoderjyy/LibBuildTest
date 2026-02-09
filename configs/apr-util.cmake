# 使用autotools构建
set(LIB_PROJECT_TYPE "autotools")

# 依赖
set(LIB_DEPENDS ${NAME_APR})

# 配置指令
set(LIB_CONFIGURE_COMMAND
        ${LIB_SOURCE_DIR}/configure
        # 安装到apr，而不是apr-util
        --prefix=${LIB_INSTALL_PREFIX}/${NAME_APR}
        # apr
        --with-apr=${LIB_INSTALL_PREFIX}/${NAME_APR}
)