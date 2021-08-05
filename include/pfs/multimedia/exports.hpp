////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021 Vladislav Trifochkin
//
// This file is part of [net-lib](https://github.com/semenovf/net-lib) library.
//
// References:
//
// Changelog:
//      2021.06.21 Initial version.
////////////////////////////////////////////////////////////////////////////////
#pragma once
#ifndef PFS_MULTIMEDIA_STATIC_LIB
#   ifndef PFS_MULTIMEDIA_DLL_API
#       if defined(_MSC_VER)
#           if defined(PFS_MULTIMEDIA_DLL_EXPORTS)
#               define PFS_MULTIMEDIA_DLL_API __declspec(dllexport)
#           else
#               define PFS_MULTIMEDIA_DLL_API __declspec(dllimport)
#           endif
#       endif
#   endif
#endif // !PFS_MULTIMEDIA_STATIC_LIB

#ifndef PFS_MULTIMEDIA_DLL_API
#   define PFS_MULTIMEDIA_DLL_API
#endif
