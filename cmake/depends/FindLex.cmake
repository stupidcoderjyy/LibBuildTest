# - Find LEX (flex/lex)
# 仅判断 lex/flex 工具是否存在，核心变量：
#  LEX_EXECUTABLE   - Path to lex/flex executable
#  LEX_FOUND        - True if lex/flex was found

# 查找可执行文件（优先 flex，兼容传统 lex）
find_program(LEX_EXECUTABLE NAMES flex lex)

# 标准函数判断是否找到（仅检查核心可执行文件）
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Lex REQUIRED_VARS LEX_EXECUTABLE)

# 标记高级变量（不在 cmake-gui 中显示）
mark_as_advanced(LEX_EXECUTABLE)