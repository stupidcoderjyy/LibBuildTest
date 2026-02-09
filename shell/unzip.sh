ZIP_DIR="./libzips"
UNZIP_DIR="./libsrc"

# 检查libzips目录是否存在
if [ ! -d "$ZIP_DIR" ]; then
    echo "错误：目录 $ZIP_DIR 不存在！"
    exit 1
fi

mkdir -p "$UNZIP_DIR"

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