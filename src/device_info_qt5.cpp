////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021,2022 Vladislav Trifochkin
//
// This file is part of `multimedia-lib`.
//
// Changelog:
//      2022.01.20 Initial version.
////////////////////////////////////////////////////////////////////////////////
#include "pfs/multimedia/audio.hpp"
#include <QAudioDeviceInfo>
#include <vector>

namespace multimedia {
namespace audio {

// Default source/input device
MULTIMEDIA__EXPORT device_info default_input_device ()
{
    device_info result;
    auto defaultInputDevice = QAudioDeviceInfo::defaultInputDevice();
    result.name = defaultInputDevice.deviceName().toStdString();
    result.readable_name = defaultInputDevice.deviceName().toStdString();

    return result;
}

// Default sink/ouput device
MULTIMEDIA__EXPORT device_info default_output_device ()
{
    device_info result;
    auto defaultOutputDevice = QAudioDeviceInfo::defaultOutputDevice();
    result.name = defaultOutputDevice.deviceName().toStdString();
    result.readable_name = defaultOutputDevice.deviceName().toStdString();

    return result;
}

MULTIMEDIA__EXPORT std::vector<device_info> fetch_devices (device_mode mode)
{
    std::vector<device_info> result;

    auto availableDevices = QAudioDeviceInfo::availableDevices(
        mode == device_mode::output
            ? QAudio::AudioOutput
            : QAudio::AudioInput);

    for (auto const & dev: availableDevices) {
        result.emplace_back(device_info{dev.deviceName().toStdString()
            , dev.deviceName().toStdString()});
    }

    return result;
}

}} // namespace multimedia::audio

