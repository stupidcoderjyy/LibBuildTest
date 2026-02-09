#!/bin/bash

# 设置脚本执行模式：遇到错误立即退出，未定义变量立即报错
set -euo pipefail

# 定义源压缩文件目录和目标解压目录
ZIP_DIR="./libzips"
UNZIP_DIR="./build/libsrc"
OUT_DIR="./build/out"
BUILD_DIR="./build"

echo "[1/3] 解压源代码"

mkdir -p "$BUILD_DIR"
mkdir -p "$UNZIP_DIR"
mkdir -p "$OUT_DIR"

# 检查libzips目录是否存在
if [ ! -d "$ZIP_DIR" ]; then
    echo "错误：目录 $ZIP_DIR 不存在！"
    exit 1
fi

# 检查libzips目录下是否有压缩文件
COMPRESS_FILES=$(find "$ZIP_DIR" -maxdepth 1 -type f \( -name "*.zip" -o -name "*.tar.gz" -o -name "*.tar.bz2" -o -name "*.tar.xz" \))
if [ -z "$COMPRESS_FILES" ]; then
    echo "警告：$ZIP_DIR 目录下未找到任何压缩文件（支持格式：zip, tar.gz, tar.bz2, tar.xz）"
else
    # 遍历并解压不同类型的压缩文件
    for file in $COMPRESS_FILES; do
        # 获取压缩包的文件名（不含路径和后缀），作为预期的解压目录名
        # 示例：libxxx-1.0.tar.gz → libxxx-1.0
        filename=$(basename "$file")
        # 移除所有压缩后缀，得到核心名称
        core_name=${filename%.zip}
        core_name=${core_name%.tar.gz}
        core_name=${core_name%.tgz}
        core_name=${core_name%.tar.bz2}
        core_name=${core_name%.tbz2}
        core_name=${core_name%.tar.xz}
        core_name=${core_name%.txz}
        
        # 检查目标目录是否已存在
        target_path="$UNZIP_DIR/$core_name"
        if [ -d "$target_path" ]; then
            echo "跳过: $file"
            continue
        fi

        # 目录不存在，执行解压
        echo "解压: $file"
        case "$file" in
            *.zip)
                unzip -q "$file" -d "$UNZIP_DIR"  # -q 静默解压，减少输出
                ;;
            *.tar.gz|*.tgz)
                tar -xzf "$file" -C "$UNZIP_DIR"
                ;;
            *.tar.bz2|*.tbz2)
                tar -xjf "$file" -C "$UNZIP_DIR"
                ;;
            *.tar.xz|*.txz)
                tar -xJf "$file" -C "$UNZIP_DIR"
                ;;
            *)
                echo "不支持的压缩格式：$file"
                ;;
        esac
    done
fi

cd "$BUILD_DIR" || { echo "错误：无法进入目录 $BUILD_DIR"; exit 1; }

echo "[2/3] 更新Cmake项目"
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