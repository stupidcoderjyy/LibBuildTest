# - Find TexInfo (makeinfo)
# 仅判断 makeinfo 工具是否存在，核心变量：
#  TEXINFO_EXECUTABLE   - Path to makeinfo executable
#  TEXINFO_FOUND        - True if makeinfo was found

# 查找 makeinfo 可执行文件
find_program(TEXINFO_EXECUTABLE NAMES makeinfo)

# 标准函数判断是否找到（仅检查核心可执行文件）
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(TexInfo REQUIRED_VARS TEXINFO_EXECUTABLE)

# 标记高级变量（不在 cmake-gui 中显示）
mark_as_advanced(TEXINFO_EXECUTABLE)