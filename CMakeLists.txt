cmake_minimum_required(VERSION 3.22 FATAL_ERROR)

project(LibBuildTest)

# 引入ExternalProject模块，用于管理外部项目的编译安装
include(ExternalProject)

# 导入依赖
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake/depends)
include(libs.cmake)

set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)
set(BUILD_TYPE Release)
set(INSTALL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/out)
set(SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libsrc)
set(CONFIG_DIR ${CMAKE_CURRENT_SOURCE_DIR}/cmake/projects)

set(${ROOT_LIBS} "")

foreach(LIB_ID ${LIB_ID_GROUP})
    cmake_language(EVAL CODE "set(LIB_NAME \${NAME_${LIB_ID}})")
    cmake_language(EVAL CODE "set(LIB_VERSIONED_NAME \${LIB_NAME}-\${VERSION_${LIB_ID}})")
    cmake_language(EVAL CODE "
        if(DEFINED ${LIB_ID}_IGNORED AND ${LIB_ID}_IGNORED)
            set(LIB_IGNORED TRUE)
        else()
            set(LIB_IGNORED FALSE)
        endif()
    ")
    if (LIB_IGNORED)
        message(STATUS "${LIB_NAME} (忽略)")
        continue()
    endif()
    # 检查源码目录
    set(LIB_SOURCE_DIR ${SRC_DIR}/${LIB_VERSIONED_NAME})
    if (NOT EXISTS ${LIB_SOURCE_DIR})
        message(FATAL_ERROR "找不到路径: ${LIB_SOURCE_DIR}")
    endif ()
    if(NOT IS_DIRECTORY ${LIB_SOURCE_DIR})
        message(WARNING "跳过文件: ${LIB_SOURCE_DIR}")
        continue()
    endif()

    # 加载项目配置文件
    set(LIB_INSTALL_PREFIX ${INSTALL_DIR}/${LIB_NAME})
    set(LIB_CONFIG_FILE ${CONFIG_DIR}/${LIB_NAME}.cmake)
    if (NOT EXISTS ${LIB_CONFIG_FILE})
        message(FATAL_ERROR "缺少项目配置：${LIB_CONFIG_FILE}")
    endif ()
    unset(LIB_CONFIGURE_COMMAND)
    unset(LIB_BUILD_COMMAND)
    unset(LIB_INSTALL_COMMAND)
    unset(LIB_DEPENDS)
    set(LIB_IS_ROOT TRUE)
    include(${LIB_CONFIG_FILE})
    if (NOT DEFINED LIB_DEPENDS OR LIB_DEPENDS STREQUAL "")
        message(STATUS "已加载：${LIB_NAME}")
    else()
        message(STATUS "已加载：${LIB_NAME} [${LIB_DEPENDS}]")
    endif()
    if(LIB_IS_ROOT)
        list(APPEND ROOT_LIBS ${LIB_NAME})
    endif()
endforeach()

add_custom_target(
        build-all
        DEPENDS ${ROOT_LIBS}
)