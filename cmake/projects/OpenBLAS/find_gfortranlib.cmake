cmake_minimum_required(VERSION 3.10)

# 仅初始化核心输出变量
set(GFORTRAN_LIB_PATH "" CACHE PATH "libgfortran库")

# 若缓存中已存在有效路径（非空、存在、软链接），直接退出
if(GFORTRAN_LIB_PATH AND EXISTS ${GFORTRAN_LIB_PATH})
    # 用Linux指令判断缓存路径是否为软链接
    execute_process(
        COMMAND bash -c "test -L \"${GFORTRAN_LIB_PATH}\""
        RESULT_VARIABLE IS_SYMLINK
        OUTPUT_QUIET
        ERROR_QUIET
    )
    # 非软链接则直接退出脚本
    if(${IS_SYMLINK} EQUAL 0)
        return()
    endif()
endif()

# 定义 libgfortran 常见存放路径（覆盖主流 Linux 发行版），避免全局搜索
set(LIB_SEARCH_PATHS
    /usr/lib
    /usr/lib64
    /usr/lib/x86_64-linux-gnu  # Ubuntu/Debian 专属
    /usr/lib/aarch64-linux-gnu # ARM 架构 Ubuntu
    /usr/local/lib
    /usr/local/lib64
    /lib
    /lib64
    /opt/lib
    /opt/local/lib
)

string(REPLACE ";" " " LIB_SEARCH_PATHS_STR "${LIB_SEARCH_PATHS}")

# 优化后的 find 命令：仅搜索指定库目录，大幅提速
set(LIBGFORTRAN_FIND_CMD
    "sudo find ${LIB_SEARCH_PATHS_STR} -name \"libgfortran*\" 2>/dev/null | grep -E \"so(\\.|$)\""
)

# 执行查找命令
execute_process(
    COMMAND bash -c ${LIBGFORTRAN_FIND_CMD}
    OUTPUT_VARIABLE LIBGFORTRAN_ALL_PATHS
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

# 处理查找结果并遍历路径
if(LIBGFORTRAN_ALL_PATHS)
    string(REPLACE "\n" ";" LIBGFORTRAN_PATH_LIST ${LIBGFORTRAN_ALL_PATHS})
    
    # 遍历路径找第一个软链接文件
    foreach(LIB_PATH ${LIBGFORTRAN_PATH_LIST})
        # 跳过空路径/不存在的路径
        if(NOT LIB_PATH OR NOT EXISTS ${LIB_PATH})
            continue()
        endif()

        # 检查是否为软链接，软链接则赋值并退出脚本
        execute_process(
            COMMAND bash -c "test -L \"${LIB_PATH}\""
            RESULT_VARIABLE IS_SYMLINK
            OUTPUT_QUIET
            ERROR_QUIET
        )
        if(${IS_SYMLINK} EQUAL 0)
            set(GFORTRAN_LIB_PATH ${LIB_PATH} CACHE PATH "libgfortran库" FORCE)
            return()
        endif()
    endforeach()
endif()

# 遍历结束后仍未找到有效路径，抛出致命错误
message(FATAL_ERROR "未找到libgfortran.so，搜索路径：${LIB_SEARCH_PATHS_STR}")