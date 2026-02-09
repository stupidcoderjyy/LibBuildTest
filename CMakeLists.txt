cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

project(LibBuildTest)

# 引入ExternalProject模块，用于管理外部项目的编译安装
include(ExternalProject)

set(APEX_LIBS
        # log4cxx及其依赖
        apr-1.7.6
        apr-util-1.6.3
        apache-log4cxx-1.4.0
)

set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)
set(BUILD_TYPE Release)
set(LIB_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/build/out)
set(LIB_SRC_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/build/libsrc)
set(LIB_CONFIG_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/configs)

foreach(LIB_NAME ${APEX_LIBS})
    set(LIB_SOURCE_DIR ${LIB_SRC_ROOT}/${LIB_NAME})
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
    set(LIB_CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX=${LIB_INSTALL_PREFIX}/${LIB_NAME}
            -DCMAKE_BUILD_TYPE=${BUILD_TYPE}
            -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
            -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
            -DBUILD_SHARED_LIBS=ON
            -DBUILD_STATIC_LIBS=OFF
    )
    set(LIB_BUILD_COMMAND make -j8)
    set(LIB_INSTALL_COMMAND make install)
    set(LIB_CONFIGURE_COMMAND ${LIB_SOURCE_DIR}/configure --prefix=${LIB_INSTALL_PREFIX})
    # 默认配置方式
    set(LIB_USE_CMAKE ON)
    # 编译当前库所需要的依赖，默认无依赖
    set(LIB_DEPENDS "")
    if(EXISTS ${LIB_CONFIG_FILE})
        # 包含配置文件（会加载该库的自定义参数，如LIB_CMAKE_ARGS、LIB_BUILD_TYPE等）
        include(${LIB_CONFIG_FILE})
    endif()

    # 3. 根据库类型（CMake/autotools）构建
    if(EXISTS ${LIB_SOURCE_DIR}/CMakeLists.txt AND LIB_USE_CMAKE)
        # CMake类型库：使用配置文件中的LIB_CMAKE_ARGS
        ExternalProject_Add(
                ${LIB_NAME}
                SOURCE_DIR ${LIB_SOURCE_DIR}
                BINARY_DIR ${LIB_SOURCE_DIR}/build
                CMAKE_ARGS ${LIB_CMAKE_ARGS}
                INSTALL_COMMAND ${LIB_INSTALL_COMMAND}
                BUILD_ALWAYS OFF
                LOG_CONFIGURE ON
                LOG_BUILD ON
                LOG_INSTALL ON
                DEPENDS ${LIB_DEPENDS}
        )

        message(STATUS "Cmake Lib: ${LIB_NAME} <= ${LIB_DEPENDS}")
    elseif(EXISTS ${LIB_SOURCE_DIR}/configure)
        # autotools类型库：使用配置文件中的LIB_CONFIGURE_COMMAND
        ExternalProject_Add(
                ${LIB_NAME}
                SOURCE_DIR ${LIB_SOURCE_DIR}
                BINARY_DIR ${LIB_SOURCE_DIR}/build
                CONFIGURE_COMMAND ${LIB_CONFIGURE_COMMAND}
                BUILD_COMMAND ${LIB_BUILD_COMMAND}
                INSTALL_COMMAND ${LIB_INSTALL_COMMAND}
                BUILD_ALWAYS OFF
                LOG_CONFIGURE ON
                LOG_BUILD ON
                LOG_INSTALL ON
                DEPENDS ${LIB_DEPENDS}
        )

        message(STATUS "Autotools Lib: ${LIB_NAME} <= ${LIB_DEPENDS}")
    else()
        message(ERROR "${LIB_NAME} 不支持自动构建，跳过")
        continue()
    endif()

    # 清空当前库的配置参数（避免污染下一个库）
    unset(LIB_CMAKE_ARGS)
    unset(LIB_CONFIGURE_COMMAND)
    unset(LIB_BUILD_COMMAND)
    unset(LIB_INSTALL_COMMAND)
    unset(LIB_DEPENDS)
    unset(LIB_USE_CMAKE)
endforeach()

add_custom_target(
        build-all
        DEPENDS ${APEX_LIBS}
        COMMENT "编译并安装所有第三方库到 ${LIB_INSTALL_PREFIX}"
)