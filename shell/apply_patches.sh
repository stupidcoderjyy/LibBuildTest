#!/bin/bash
set -euo pipefail

# ===================== 路径配置 =====================
# 源目录（补丁文件所在路径，相对于脚本执行目录）
PATCH_SRC_DIR="./shell/patches"
# 目标目录（复制目标路径，相对于脚本执行目录）
PATCH_DEST_DIR="./libsrc"

# ===================== 核心逻辑 =====================
# 确保目标根目录存在（不存在则创建，多级目录也支持）
mkdir -p "$PATCH_DEST_DIR"

# 遍历源目录中的所有文件（仅处理文件，跳过目录/符号链接等）
find "$PATCH_SRC_DIR" -type f -print0 | while IFS= read -r -d '' file_path; do
    # 使用参数扩展去掉"$PATCH_SRC_DIR/"前缀，得到源文件的相对路径
    file_src_path="${file_path#$PATCH_SRC_DIR/}"
    
    # 目标文件路径 = 目标根目录 + 源文件相对路径（保留目录结构）
    dest_file_path="$PATCH_DEST_DIR/$file_src_path"
    
    # 提取目标文件的目录部分并创建（支持多级目录），加sudo避免权限问题
    sudo mkdir -p "$(dirname "$dest_file_path")"
    
    # 强制复制文件到目标路径（覆盖已有文件），保留sudo权限
    sudo cp -f "$file_path" "$dest_file_path"
    
    # 输出提示：显示源文件和目标文件的完整路径（更直观）
    echo "覆盖: $file_src_path"
done

exit 0