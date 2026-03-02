#!/bin/bash

# 定义压缩包名称 -> 官方下载地址的映射（均为各开源项目官方/可信镜像源）
declare -A pkg_map=(
    ["mpfr-4.2.1.tar.gz"]="https://www.mpfr.org/mpfr-4.2.1/mpfr-4.2.1.tar.gz"
    ["OpenBLAS-0.3.29.tar.gz"]="https://codeload.github.com/OpenMathLib/OpenBLAS/tar.gz/refs/tags/v0.3.29"
    ["openssl-3.6.1.tar.gz"]="https://www.openssl.org/source/openssl-3.6.1.tar.gz"
    ["poco-1.12.4.tar.gz"]="https://codeload.github.com/pocoproject/poco/tar.gz/refs/tags/poco-1.12.4-release"
    ["SuiteSparse-7.2.2.tar.gz"]="https://codeload.github.com/DrTimothyAldenDavis/SuiteSparse/tar.gz/refs/tags/v7.2.2"
    ["texinfo-7.1.tar.gz"]="https://ftp.gnu.org/gnu/texinfo/texinfo-7.1.tar.gz"
    ["zstd-1.5.6.tar.gz"]="https://codeload.github.com/facebook/zstd/tar.gz/refs/tags/v1.5.6"
    ["apr-1.7.6.tar.gz"]="https://archive.apache.org/dist/apr/apr-1.7.6.tar.gz"
    ["apr-util-1.6.3.tar.gz"]="https://archive.apache.org/dist/apr/apr-util-1.6.3.tar.gz"
    ["automake-1.16.5.tar.gz"]="https://ftp.gnu.org/gnu/automake/automake-1.16.5.tar.gz"
    ["boost-1.83.0.tar.gz"]="https://boostorg.jfrog.io/artifactory/main/release/1.83.0/source/boost_1_83_0.tar.gz"
    ["cpptrace-0.7.3.tar.gz"]="https://github.com/jeremy-rifkin/cpptrace/archive/refs/tags/v0.7.3.tar.gz"
    ["curl-8.1.2.tar.gz"]="https://curl.se/download/curl-8.1.2.tar.gz"
    ["dwarf-0.11.0.tar.gz"]="https://codeload.github.com/davea42/libdwarf-code/tar.gz/refs/tags/v0.11.0"
    ["gmp-6.1.2.tar.xz"]="https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz"
    ["isl-0.27.tar.gz"]="https://libisl.sourceforge.io/isl-0.27.tar.gz"
    ["libzip-1.10.1.tar.gz"]="https://libzip.org/download/libzip-1.10.1.tar.gz"
    ["log4cxx-1.4.0.tar.gz"]="https://archive.apache.org/dist/logging/log4cxx/1.4.0/apache-log4cxx-1.4.0.tar.gz"
    ["mpc-1.3.1.tar.gz"]="https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz"
)

# 确保libzips目录存在（不存在则创建，无多余输出）
mkdir -p ./libzips

# 遍历所有压缩包，检查并下载
for pkg_name in "${!pkg_map[@]}"; do
    # 拼接压缩包的本地路径
    local_pkg_path="./libzips/${pkg_name}"
    # 获取对应的下载地址
    download_url="${pkg_map[$pkg_name]}"

    # 检查文件是否已存在
    if [ -f "${local_pkg_path}" ]; then
        continue  # 跳过当前包，处理下一个
    fi

    # 输出下载提示
    echo "下载${pkg_name}"

    # 静默下载（-s：静默模式，-S：出错时显示信息，-L：跟随重定向）
    # -o 指定下载文件的输出路径（即重命名为映射中的压缩包名称）
    curl -sSL "${download_url}" -o "${local_pkg_path}" || {
        # 下载失败时输出错误到标准错误流，退出脚本
        echo "下载${pkg_name}失败" >&2
        exit 1
    }
done