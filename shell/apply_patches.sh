#!/bin/bash
set -euo pipefail

# ===================== 路径配置 =====================
# 源目录（补丁文件所在路径，相对于脚本执行目录）
PATCH_SRC_DIR="./shell/patches"
# 目标目录（复制目标路径，相对于脚本执行目录）
PATCH_DEST_DIR="./libsrc"

# ===================== 核心逻辑 =====================
# 确保目标目录存在（不存在则创建，多级目录也支持）
mkdir -p "$PATCH_DEST_DIR"

# 遍历源目录中的所有文件（仅处理文件，跳过目录/符号链接等）
find "$PATCH_SRC_DIR" -type f -print0 | while IFS= read -r -d '' file_path; do
    # 强制复制文件到目标目录（覆盖已有文件），保留sudo权限
    sudo cp -f "$file_path" "$PATCH_DEST_DIR/"
    
    # 输出提示：路径为相对于脚本执行目录的完整相对路径
    echo "覆盖: $file_path"
done

exit 0