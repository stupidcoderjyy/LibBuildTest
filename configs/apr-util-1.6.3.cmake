# 使用autotools构建
set(LIB_USE_CMAKE OFF)

set(LIB_DEPENDS apr-1.7.6)

set(LIB_CONFIGURE_COMMAND
        ${LIB_CONFIGURE_COMMAND}
        # apr
        --with-apr=${LIB_INSTALL_PREFIX}
)