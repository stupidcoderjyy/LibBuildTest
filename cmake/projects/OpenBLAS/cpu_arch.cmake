#
# 用于获取OPENBLAS_TARGET
#
set(OPENBLAS_TARGET "GENERIC" CACHE STRING "Auto-detected OpenBLAS target")

execute_process(
    COMMAND arch
    OUTPUT_VARIABLE ARCH_RESULT
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
message(STATUS "cpu arch: ${ARCH_RESULT}")

string(TOLOWER "${ARCH_RESULT}" ARCH_RESULT_LOWER)

if(ARCH_RESULT_LOWER MATCHES "x86_64|amd64|i86pc")
    set(OPENBLAS_TARGET "CORE2")          # 所有64位x86架构统一用CORE2
elseif(ARCH_RESULT_LOWER MATCHES "i386|i486|i586")
    set(OPENBLAS_TARGET "IA32")           # 早期32位x86统一用IA32
elseif(ARCH_RESULT_LOWER MATCHES "i686")
    set(OPENBLAS_TARGET "PENTIUM4")       # 32位x86主流统一用PENTIUM4
elseif(ARCH_RESULT_LOWER MATCHES "aarch64|arm64|aarch64_be")
    set(OPENBLAS_TARGET "ARMv8")          # 所有64位ARM架构统一用ARMv8
elseif(ARCH_RESULT_LOWER MATCHES "armv7l|armv7a|armeb")
    set(OPENBLAS_TARGET "ARMv7")          # 32位ARMv7统一用ARMv7
elseif(ARCH_RESULT_LOWER MATCHES "armv6l")
    set(OPENBLAS_TARGET "ARMv6")          # ARMv6统一用ARMv6
elseif(ARCH_RESULT_LOWER MATCHES "arm|armv5l")
    set(OPENBLAS_TARGET "ARMv5")          # 早期ARMv5统一用ARMv5
elseif(ARCH_RESULT_LOWER MATCHES "ppc64|ppc64le")
    set(OPENBLAS_TARGET "POWER8")         # 所有64位PowerPC统一用POWER8
elseif(ARCH_RESULT_LOWER MATCHES "ppc32|powerpc")
    set(OPENBLAS_TARGET "GENERIC")        # 32位PowerPC用GENERIC
elseif(ARCH_RESULT_LOWER MATCHES "mips64|mips64el|mips|mipsel")
    set(OPENBLAS_TARGET "GENERIC")        # 所有MIPS架构用GENERIC
elseif(ARCH_RESULT_LOWER MATCHES "riscv64|riscv32")
    set(OPENBLAS_TARGET "GENERIC")        # 所有RISC-V架构用GENERIC
else()
    set(OPENBLAS_TARGET "GENERIC")        # 未知架构保底用GENERIC
endif()