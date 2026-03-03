#!/bin/bash

unzip() {
    ./shell/unzip.sh
    if ! sudo ./shell/permission.sh --./shell/permissions/lib_files.txt; then
        echo "库文件权限设置失败" >&2
        exit 1
    fi
}

apply_patches() {
    ./shell/apply_patches.sh
}

build() {
    # 定义源压缩文件目录和目标解压目录
    OUT_DIR="./out"
    BUILD_DIR="./build"

    mkdir -p "$BUILD_DIR"
    mkdir -p "$OUT_DIR"

    cd "$BUILD_DIR" || { echo "错误：无法进入目录 $BUILD_DIR"; exit 1; }

    if ! sudo cmake .. ; then
        echo "错误：cmake 构建失败！" >&2  # 将错误信息输出到标准错误流
        exit 1  # 退出脚本，退出码为1表示执行失败
    fi
}

install() {
    # cmake执行成功后，执行make build-all
    if ! sudo make build-all; then
        echo "错误：make build-all 执行失败！" >&2
        exit 1
    fi
}

# 设置脚本执行模式：遇到错误立即退出，未定义变量立即报错
set -euo pipefail

sudo chmod u+x ./shell/permission.sh
sudo chmod u+r ./shell/permissions/core_files.txt
if ! sudo ./shell/permission.sh --./shell/permissions/core_files.txt; then
    echo "核心脚本权限设置失败" >&2
    exit 1
fi

echo "[1/4] 解压源代码"
unzip

echo "[2/4] 修改源码"
apply_patches

echo "[3/4] 更新Cmake"
build

echo "[4/4] 编译并安装依赖库"
install

echo "编译成功"
