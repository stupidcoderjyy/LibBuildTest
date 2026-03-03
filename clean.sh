#!/bin/bash

# 定义需要操作的目标文件夹列表
TARGET_DIRS=("build" "libsrc" "out")

# 显示用法提示的函数
show_usage() {
    echo "用法: $0 [--<LIB_NAME> [--<LIB_NAME> ...] | --all]"
    echo "示例:"
    echo "  $0 --mylib          # 删除 build/libsrc/out 中以 mylib 为前缀的文件夹"
    echo "  $0 --dwarf --cpptrace # 删除 build/libsrc/out 中以 dwarf/cpptrace 为前缀的文件夹"
    echo "  $0 --all            # 清空 build/libsrc/out 文件夹内的所有内容"
}

# 检查参数数量是否为空
if [ $# -eq 0 ]; then
    echo "错误: 未传入任何参数"
    show_usage
    exit 1
fi

# 标记是否包含 --all 参数
has_all=0
# 存储所有库名参数（去掉 -- 前缀）
LIB_NAMES=()

# 遍历所有输入参数，提取有效信息并校验
for arg in "$@"; do
    # 去掉参数的 -- 前缀
    stripped_arg=${arg#--}
    
    if [ "$stripped_arg" = "all" ]; then
        has_all=1
        # 如果 --all 和其他参数共存，直接报错
        if [ ${#LIB_NAMES[@]} -gt 0 ]; then
            echo "错误: --all 不能与其他库名参数同时使用"
            show_usage
            exit 1
        fi
    else
        # 如果已经识别到 --all，又出现其他参数，报错
        if [ $has_all -eq 1 ]; then
            echo "错误: --all 不能与其他库名参数同时使用"
            show_usage
            exit 1
        fi
        # 将合法的库名加入列表
        LIB_NAMES+=("$stripped_arg")
    fi
done

# 处理 --all 情况：清空所有目标文件夹内容
if [ $has_all -eq 1 ]; then
    for dir in "${TARGET_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            sudo rm -rf "$dir"/*
        fi
    done
    exit 0
fi

# 处理多个库名参数：逐个删除对应前缀的文件夹
for lib_name in "${LIB_NAMES[@]}"; do
    for dir in "${TARGET_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            # 查找并删除指定前缀的文件夹
            sudo find "$dir" -maxdepth 1 -type d -name "${lib_name}*" -exec rm -rf {} +
        fi
    done
done

exit 0