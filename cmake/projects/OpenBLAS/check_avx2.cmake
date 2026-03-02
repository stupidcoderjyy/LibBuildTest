#
# 用于获取AVX2_NOT_SUPPORTED
#

# 执行 lscpu | grep -i avx2 命令
execute_process(
    COMMAND sh -c "lscpu | grep -i avx2"  # 用sh -c包裹管道命令，避免cmake解析错误
    OUTPUT_VARIABLE LSCPU_AVX2_OUTPUT     # 捕获命令输出（非空则表示有AVX2标识）
    ERROR_QUIET                           # 忽略命令执行错误（如lscpu不存在的极端情况）
    OUTPUT_STRIP_TRAILING_WHITESPACE      # 去除输出末尾的换行/空格，避免空行干扰判断
)

# 判断输出是否非空：非空→支持，空→不支持
if(LSCPU_AVX2_OUTPUT)
    message(STATUS "AVX2 +")
    set(AVX2_NOT_SUPPORTED 0)
else()
    message(STATUS "AVX2 -")
    set(AVX2_NOT_SUPPORTED 1)
endif()