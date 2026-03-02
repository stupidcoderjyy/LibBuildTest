set(NAME_AUTOMAKE automake)
set(NAME_APR apr)
set(NAME_APR_UTIL apr-util)
set(NAME_LOG4CXX log4cxx)
set(NAME_BOOST boost)
set(NAME_CPPTRACE cpptrace)
set(NAME_CURL curl)
set(NAME_OPENSSL openssl)
set(NAME_GMP gmp)
set(NAME_ISL isl)
set(NAME_LIBZIP libzip)
set(NAME_MPC mpc)
set(NAME_MPFR mpfr)
set(NAME_OPENBLAS OpenBLAS)
set(NAME_POCO poco)
set(NAME_SUITESPARSE SuiteSparse)
set(NAME_ZSTD zstd)
set(NAME_DWARF dwarf)
set(NAME_TEXINFO texinfo)

set(VERSION_AUTOMAKE "1.16.5")
set(VERSION_APR "1.7.6")
set(VERSION_APR_UTIL "1.6.3")
set(VERSION_LOG4CXX "1.4.0")
set(VERSION_BOOST "1.83.0")
set(VERSION_CPPTRACE "0.7.3")
set(VERSION_CURL "8.1.2")
set(VERSION_OPENSSL "3.6.1")
set(VERSION_GMP "6.1.2")
set(VERSION_ISL "0.27")
set(VERSION_LIBZIP "1.10.1")
set(VERSION_MPC "1.3.1")
set(VERSION_MPFR "4.2.1")
set(VERSION_OPENBLAS "0.3.29")
set(VERSION_POCO "1.12.4")
set(VERSION_SUITESPARSE "7.2.2")
set(VERSION_ZSTD "1.5.6")
set(VERSION_DWARF "0.11.0")
set(VERSION_TEXINFO "7.1")

set(LIB_ID_GROUP
        # 库               依赖
        AUTOMAKE
        APR
        APR_UTIL           # APR
        LOG4CXX            # APR APR_UTIL
        ZSTD
        BOOST              # ZSTD
        CPPTRACE           # ZSTD DWARF 这两个库随着cpptrace一起编译

        OPENSSL
        CURL               # OPENSSL
        
        # TEXINFO
        GMP                # lex（必须预先安装） AUTOMAKE
        LIBZIP
        ISL                # GMP LIBZIP
        MPFR               # GMP AUTOMAKE
        MPC                # GMP MPFR
        
        OPENBLAS           # ISL  
        SUITESPARSE        # OPENBLAS GMP MPFR

        POCO               # APR APR_UTIL OPENSSL ISL
)

# 检查外部依赖
find_package(Lex REQUIRED)
find_package(TexInfo)

set(TEXINFO_IGNORED ${TexInfo_FOUND})