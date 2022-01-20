////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021 Vladislav Trifochkin
//
// This file is part of [net-lib](https://github.com/semenovf/net-lib) library.
//
// References:
//
// Changelog:
//      2021.06.21 Initial version.
//      2022.01.20 Renamed macros.
////////////////////////////////////////////////////////////////////////////////
#pragma once

#ifndef MULTIMEDIA__STATIC
#   ifndef MULTIMEDIA__EXPORT
#       if _MSC_VER
#           if defined(MULTIMEDIA__EXPORTS)
#               define MULTIMEDIA__EXPORT __declspec(dllexport)
#           else
#               define MULTIMEDIA__EXPORT __declspec(dllimport)
#           endif
#       else
#           define MULTIMEDIA__EXPORT
#       endif
#   endif
#else
#   define MULTIMEDIA__EXPORT
#endif // !MULTIMEDIA__STATIC
