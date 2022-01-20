////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021 Vladislav Trifochkin
//
// This file is part of `multimedia-lib`.
//
// Changelog:
//      2021.08.03 Initial version.
////////////////////////////////////////////////////////////////////////////////
#pragma once
#include "exports.hpp"
#include <string>
#include <vector>

namespace multimedia {
namespace audio {

enum class device_mode
{
      output  = 0x01
    , input   = 0x02
};

struct device_info
{
    std::string name;
    std::string readable_name;
};

MULTIMEDIA__EXPORT device_info default_input_device ();  // default source/input device
MULTIMEDIA__EXPORT device_info default_output_device (); // default sink/output device
MULTIMEDIA__EXPORT std::vector<device_info> fetch_devices (device_mode mode);

}} // namespace multimedia::audio
