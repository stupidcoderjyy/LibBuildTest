#!/bin/bash

# 定义核心目录路径（可根据实际路径修改）
OUT_DIR="./out"
LIBZIPS_DIR="./libzips"
# 输出目录
OUT_NAMED_DIR="./out_named"


# 功能：去除文件的常见后缀（压缩包/库文件后缀），返回纯“库名-版本号”部分
# 示例：apr-1.0.5.tar.gz → apr-1.0.5；log4cxx-2.1.0.zip → log4cxx-2.1.0；zlib-1.2.13.so → zlib-1.2.13
remove_file_suffix() {
    local file_name="$1"
    # 定义需要去除的常见后缀（按优先级排序，长后缀在前）
    local suffixes=(
        ".tar.gz" ".tar.bz2" ".tar.xz" ".tgz"
        ".zip" ".7z" ".rar"
        ".so" ".so.1" ".a" ".dll" ".dylib"
        ".txt" ".md"
    )
    # 遍历后缀，匹配到则去除
    for suffix in "${suffixes[@]}"; do
        if [[ "${file_name}" == *"${suffix}" ]]; then
            file_name="${file_name%${suffix}}"
        fi
    done
    echo "${file_name}"
}

rename() {
    mkdir -p "${OUT_NAMED_DIR}"

    # 检查out目录是否存在
    if [ ! -d "${OUT_DIR}" ]; then
        echo "错误：目录 ${OUT_DIR} 不存在！"
        exit 1
    fi

    # 检查libzips目录是否存在
    if [ ! -d "${LIBZIPS_DIR}" ]; then
        echo "错误：目录 ${LIBZIPS_DIR} 不存在！"
        exit 1
    fi

    # 检查libzips目录是否为空
    if [ -z "$(ls -A ${LIBZIPS_DIR})" ]; then
        echo "警告：目录 ${LIBZIPS_DIR} 为空，无需重命名！"
        exit 0
    fi

    # 遍历libzips下的所有文件（仅处理普通文件，跳过子目录）
    for zip_file in "${LIBZIPS_DIR}"/*; do
        # 跳过目录（只处理文件）
        if [ -d "${zip_file}" ]; then
            continue
        fi

        # 1. 获取纯文件名（去掉路径），如 "./libzips/apr-1.0.5.tar.gz" → "apr-1.0.5.tar.gz"
        file_name=$(basename "${zip_file}")

        # 2. 去除文件后缀名（核心修正），如 "apr-1.0.5.tar.gz" → "apr-1.0.5"
        pure_name=$(remove_file_suffix "${file_name}")
        if [ -z "${pure_name}" ] || [ "${pure_name}" = "${file_name}" ]; then
            # 无后缀或未匹配到常见后缀，直接使用原文件名
            pure_name="${file_name}"
        fi

        # 3. 拆分库名和版本号（按最后一个"-"拆分，兼容库名含"-"）
        lib_name=$(echo "${pure_name}" | rev | cut -d'-' -f2- | rev)
        version=$(echo "${pure_name}" | rev | cut -d'-' -f1 | rev)

        # 检查版本号是否有效（避免文件名无"-"的情况）
        if [ -z "${version}" ] || [ "${lib_name}" = "${pure_name}" ]; then
            echo "跳过：文件 ${file_name} 无有效版本号（格式非 库名-版本号）"
            continue
        fi

        # 4. 定义原目录和目标目录路径
        original_dir="${OUT_DIR}/${lib_name}"
        target_dir="${OUT_NAMED_DIR}/${pure_name}"  # 用去除后缀后的"库名-版本号"作为目标名

        # 5. 执行重命名（带安全检查）
        echo "${target_dir}"
        if [ -d "${original_dir}" ]; then
            if [ -d "${target_dir}" ]; then
                echo "跳过：${target_dir} 目标目录已存在"
            else
                cp -r "${original_dir}" "${target_dir}"
            fi
        else
            echo "跳过：${original_dir} 目录不存在"
        fi
    done
}

rename