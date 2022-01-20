////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021 Vladislav Trifochkin
//
// This file is part of [multimedia-lib](https://github.com/semenovf/multimedia-lib) library.
//
// Changelog:
//      2021.08.03 Initial version.
////////////////////////////////////////////////////////////////////////////////
#include "pfs/multimedia/audio.hpp"
#include <iostream>
#include <iomanip>
#include <string>
#include <cerrno>

using namespace multimedia;

int main (int argc, char * argv[])
{
    auto default_input_device = audio::default_input_device();
    auto default_output_device = audio::default_output_device();

    std::cout << "Default input device:\n"
        << "\tname=" << default_input_device.name << "\n"
        << "\treadable name=" << default_input_device.readable_name << "\n";

    std::cout << "Default output device:\n"
        << "\tname=" << default_output_device.name << "\n"
        << "\treadable name=" << default_output_device.readable_name << "\n";

    std::string indent{"     "};
    std::string   mark{"  (*)"};
    std::string * prefix = & indent;

    int counter = 0;
    auto input_devices = audio::fetch_devices(audio::device_mode::input);

    std::cout << "Input devices:\n";

    for (auto const & d: input_devices) {
        prefix = (d.name == default_input_device.name)
            ? & mark : & indent;
        std::cout << *prefix << std::setw(2) << ++counter << ". " << d.readable_name << "\n";
        std::cout << indent << "    name: " << d.name << "\n";
    }

    auto output_devices = audio::fetch_devices(audio::device_mode::output);
    counter = 0;

    std::cout << "Output devices:\n";

    for (auto const & d: output_devices) {
        prefix = (d.name == default_output_device.name)
            ? & mark : & indent;
        std::cout << *prefix << std::setw(2) << ++counter << ". " << d.readable_name << "\n";
        std::cout << indent << "    name: " << d.name << "\n";
    }

    return EXIT_SUCCESS;
}
