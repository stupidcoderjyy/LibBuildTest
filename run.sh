#!/bin/bash

# 设置脚本执行模式：遇到错误立即退出，未定义变量立即报错
set -euo pipefail

echo "[1/3] 解压源代码"

# 解压到libsrc
if ! ./shell/unzip.sh; then
    exit 1
fi

echo "[2/3] 更新Cmake"

# 定义源压缩文件目录和目标解压目录
OUT_DIR="./out"
BUILD_DIR="./build"

mkdir -p "$BUILD_DIR"
mkdir -p "$OUT_DIR"

cd "$BUILD_DIR" || { echo "错误：无法进入目录 $BUILD_DIR"; exit 1; }

if ! cmake ..; then
    echo "错误：cmake 构建失败！" >&2  # 将错误信息输出到标准错误流
    exit 1  # 退出脚本，退出码为1表示执行失败
fi

echo "[3/3] 编译并安装依赖库"
# cmake执行成功后，执行make build-all
if ! make build-all; then
    echo "错误：make build-all 执行失败！" >&2
    exit 1
fi

echo "编译成功"