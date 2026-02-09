# 定义要删除的目录
BUILD_DIR="./build"

# 静默删除构建目录（存在则删，不存在不报错）
[ -d "$BUILD_DIR" ] && rm -rf "$BUILD_DIR"