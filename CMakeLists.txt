cmake_minimum_required(VERSION 3.16 FATAL_ERROR)

project(LibBuildTest)

# 引入ExternalProject模块，用于管理外部项目的编译安装
include(ExternalProject)

#导入依赖
include(Dependencies.cmake)

set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)
set(BUILD_TYPE Release)
set(LIB_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/out)
set(LIB_SRC_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/libsrc)
set(LIB_CONFIG_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/configs)

set(${LIB_NAME_GROUP} "")

# 动态执行代码的宏
macro(cmake_language_eval_316 code_str)
    # 生成唯一的临时文件路径（避免多调用冲突）
    set(temp_eval_file "${CMAKE_BINARY_DIR}/eval_temp_${CMAKE_CURRENT_LIST_LINE}.cmake")
    # 将动态代码写入临时文件
    file(WRITE ${temp_eval_file} "${code_str}")
    # 执行临时文件（等价于 EVAL 执行代码）
    include(${temp_eval_file})
    # 清理临时文件（可选，避免冗余）
    file(REMOVE ${temp_eval_file})
endmacro()

foreach(LIB_ID ${LIB_ID_GROUP})
    # 获取名称，如apr
    cmake_language_eval_316("set(LIB_NAME \${NAME_${LIB_ID}})")
    # 获取带版本号的全称，如apr-1.7.6
    cmake_language_eval_316("set(LIB_VERSIONED_NAME ${LIB_NAME}-\${VERSION_${LIB_ID}})")
    # 库根目录
    set(LIB_SOURCE_DIR ${LIB_SRC_ROOT}/${LIB_VERSIONED_NAME})
    # 检查路径的存在性
    if (NOT EXISTS ${LIB_SOURCE_DIR})
        message(WARNING "找不到路径: ${LIB_SOURCE_DIR}")
    endif ()

    # 仅处理目录（过滤文件）
    if(NOT IS_DIRECTORY ${LIB_SOURCE_DIR})
        message(WARNING "跳过文件: ${LIB_SOURCE_DIR}")
        continue()
    endif()

    # 2. 查找该库的专属配置文件（命名规范：库名.cmake）
    set(LIB_CONFIG_FILE ${LIB_CONFIG_ROOT}/${LIB_NAME}.cmake)

    # 设置默认参数
    # 默认cmake命令参数
    set(LIB_CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX=${LIB_INSTALL_PREFIX}/${LIB_NAME}
            -DCMAKE_BUILD_TYPE=${BUILD_TYPE}
            -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
            -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
            -DBUILD_SHARED_LIBS=ON
            -DBUILD_STATIC_LIBS=OFF
    )
    # 默认构建命令
    set(LIB_BUILD_COMMAND make -j8)
    # 默认安装命令
    set(LIB_INSTALL_COMMAND make install)
    # autotools项目默认配置命令
    set(LIB_CONFIGURE_COMMAND
            ${LIB_SOURCE_DIR}/configure
            --prefix=${LIB_INSTALL_PREFIX}/${LIB_NAME}
    )

    # 默认项目配置
    if (EXISTS ${LIB_SOURCE_DIR}/CMakeLists.txt)
        set(LIB_PROJECT_TYPE "cmake")
    else ()
        set(LIB_PROJECT_TYPE "autotools")
    endif ()

    # 编译当前库所需要的依赖，默认无依赖
    set(LIB_DEPENDS "")

    # 覆盖默认值
    if(EXISTS ${LIB_CONFIG_FILE})
        # 包含配置文件（会加载该库的自定义参数，如LIB_CMAKE_ARGS、LIB_BUILD_TYPE等）
        include(${LIB_CONFIG_FILE})
    endif()

    # 加载项目配置文件
    set(PROJECT_CFG_PATH ${LIB_CONFIG_ROOT}/projects/${LIB_PROJECT_TYPE}.cmake)
    if (NOT EXISTS ${PROJECT_CFG_PATH})
        message(FATAL_ERROR "缺少项目配置：${PROJECT_CFG_PATH}")
    endif ()

    include(${PROJECT_CFG_PATH})
    message(STATUS "[${LIB_PROJECT_TYPE}] ${LIB_NAME} <= ${LIB_DEPENDS}")

    list(APPEND LIB_NAME_GROUP ${LIB_NAME})

    # 清空配置参数
    unset(LIB_CMAKE_ARGS)
    unset(LIB_CONFIGURE_COMMAND)
    unset(LIB_BUILD_COMMAND)
    unset(LIB_INSTALL_COMMAND)
    unset(LIB_DEPENDS)
    unset(LIB_PROJECT_TYPE)
endforeach()

add_custom_target(
        build-all
        DEPENDS ${LIB_NAME_GROUP}
)