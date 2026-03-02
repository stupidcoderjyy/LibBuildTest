#!/bin/bash

# 初始化文件列表路径变量
FILE_LIST=""

# 第一步：解析命令行参数（格式：--<文件路径>）
if [ $# -eq 0 ]; then
    echo "错误：未传入文件列表路径！"
    echo "使用方法：$0 --<文件列表路径>"
    echo "示例：$0 --./chmod_commands.txt"
    exit 1
fi

# 提取 -- 后的路径
ARG="$1"
if [[ "$ARG" =~ ^-- ]]; then
    FILE_LIST="${ARG#--}"
else
    echo "错误：参数格式不正确！必须以 -- 开头，后跟文件路径。"
    echo "使用方法：$0 --<文件列表路径>"
    exit 1
fi

# 第二步：检查文件列表是否存在且非空
if [ ! -f "$FILE_LIST" ]; then
    echo "错误：找不到文件列表 $FILE_LIST，请确认路径是否正确！"
    exit 1
fi

if [ ! -s "$FILE_LIST" ]; then
    echo "警告：$FILE_LIST 文件为空，没有需要执行的命令！"
    exit 0
fi

# 获取当前用户（用户名:用户组，确保所有权设置完整）
CURRENT_USER="$USER"
CURRENT_GROUP="$USER"  # 通常用户组与用户名相同，若需自定义可修改此处

# 错误标志位
ERROR_OCCURRED=0

# 第三步：逐行解析并执行命令
while IFS= read -r line; do
    # 跳过空行和注释行
    if [ -z "$line" ] || [[ "$line" =~ ^# ]]; then
        continue
    fi

    # 提取前缀 [u] 或 [p]（匹配行首的 [u] 或 [p]）
    if [[ "$line" =~ ^\[u\] ]]; then
        TYPE="u"
        # 移除前缀 [u] 并去除首尾空格，得到chmod参数
        CHMOD_ARGS=$(echo "$line" | sed 's/^\[u\]//' | xargs)
    elif [[ "$line" =~ ^\[p\] ]]; then
        TYPE="p"
        # 移除前缀 [p] 并去除首尾空格，得到chmod参数
        CHMOD_ARGS=$(echo "$line" | sed 's/^\[p\]//' | xargs)
    else
        echo "跳过无效行：$line（前缀必须是 [u] 或 [p]）"
        continue
    fi

    # 提取目标文件/目录路径（CHMOD_ARGS的最后一个元素）
    TARGET_PATH=$(echo "$CHMOD_ARGS" | awk '{print $NF}')

    # 检查目标路径是否存在（不存在则提示并跳过）
    if [ ! -e "$TARGET_PATH" ]; then
        echo "跳过：目标路径 $TARGET_PATH 不存在"
        continue
    fi

    # 执行chmod命令
    if chmod $CHMOD_ARGS; then
        echo "成功：chmod $CHMOD_ARGS"
        CMD_CHOWN="chown $CURRENT_USER:$CURRENT_GROUP $TARGET_PATH"
        # 如果是[u]类型，执行chown设置所有权
        if [ "$TYPE" = "u" ]; then
            if chown "$CURRENT_USER:$CURRENT_GROUP" "$TARGET_PATH"; then
                echo "成功：$CMD_CHOWN"
            else
                echo "失败：$CMD_CHOWN（可能需要sudo权限）"
                ERROR_OCCURRED=1
            fi
        fi
    else
        echo "失败：$CMD_CHOWN"
        $ERROR_OCCURRED=1
    fi
done < "$FILE_LIST"

exit $ERROR_OCCURRED