################################################################################
# Copyright (c) 2021,2022 Vladislav Trifochkin
#
# This file is part of [multimedia-lib](https://github.com/semenovf/multimedia-lib) library.
#
# Changelog:
#      2021.08.03 Initial version.
#      2022.01.20 Refactored for use `portable_target`.
################################################################################
cmake_minimum_required (VERSION 3.11)
project(multimedia CXX)

option(MULTIMEDIA__ENABLE_PULSEAUDIO "Enable PulseAudio as backend" ON)
option(MULTIMEDIA__ENABLE_QT5 "Enable Qt5 Multimedia as backend" OFF)
set(_audio_backend_FOUND OFF)

portable_target(ADD_SHARED ${PROJECT_NAME} ALIAS pfs::multimedia 
    EXPORTS MULTIMEDIA__EXPORTS
    BIND_STATIC ${PROJECT_NAME}-static 
    STATIC_ALIAS pfs::multimedia::static 
    STATIC_EXPORTS MULTIMEDIA__STATIC)
portable_target(INCLUDE_DIRS ${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_LIST_DIR}/include)

if (MULTIMEDIA__ENABLE_QT5)
    #find_package(Qt5 COMPONENTS Core Multimedia REQUIRED)

    portable_target(SOURCES ${PROJECT_NAME} ${CMAKE_CURRENT_LIST_DIR}/src/device_info_qt5.cpp)

    portable_target(LINK_QT5_COMPONENTS ${PROJECT_NAME} PRIVATE Core Gui Network Multimedia)
    portable_target(LINK_QT5_COMPONENTS ${PROJECT_NAME}-static PRIVATE Core Gui Network Multimedia)

    portable_target(DEFINITIONS ${PROJECT_NAME} PUBLIC "MULTIMEDIA__QT5_CORE_ENABLED=1")
    portable_target(DEFINITIONS ${PROJECT_NAME}-static PUBLIC "MULTIMEDIA__QT5_CORE_ENABLED=1")

    portable_target(DEFINITIONS ${PROJECT_NAME} PUBLIC "MULTIMEDIA__QT5_MULTIMEDIA_ENABLED=1")
    portable_target(DEFINITIONS ${PROJECT_NAME}-static PUBLIC "MULTIMEDIA__QT5_MULTIMEDIA_ENABLED=1")

    set(_audio_backend_FOUND ON)
endif(MULTIMEDIA__ENABLE_QT5)

if (NOT _audio_backend_FOUND)
    #if (UNIX AND NOT APPLE AND NOT CYGWIN)
    if (${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
        if (MULTIMEDIA__ENABLE_PULSEAUDIO)
            # In Ubuntu it is a part of 'libpulse-dev' package
            find_package(PulseAudio)

            if (PULSEAUDIO_FOUND)
                message(STATUS "PulseAudio version: ${PULSEAUDIO_VERSION}")

                portable_target(SOURCES ${PROJECT_NAME}
                    ${CMAKE_CURRENT_LIST_DIR}/src/device_info_pulseaudio.cpp)
                portable_target(INCLUDE_DIRS ${PROJECT_NAME} PRIVATE ${PULSEAUDIO_INCLUDE_DIR})

                portable_target(LINK ${PROJECT_NAME} PRIVATE ${PULSEAUDIO_LIBRARY})
                portable_target(LINK ${PROJECT_NAME}-static PRIVATE ${PULSEAUDIO_LIBRARY})

                portable_target(DEFINITIONS ${PROJECT_NAME} PRIVATE "MULTIMEDIA__PULSE_AUDIO_PLATFORM=1")
                portable_target(DEFINITIONS ${PROJECT_NAME}-static PRIVATE "MULTIMEDIA__PULSE_AUDIO_PLATFORM=1")

                set(_audio_backend_FOUND ON)
            endif()
        endif()
    elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
        portable_target(SOURCES ${PROJECT_NAME}
            ${CMAKE_CURRENT_LIST_DIR}/src/device_info_win32.cpp)
        set(_audio_backend_FOUND ON)
    endif()
endif()

if (NOT _audio_backend_FOUND)
    message(FATAL_ERROR
        " No any Audio backend found\n"
        " For Debian-based distributions it may be PulseAudio ('libpulse-dev' package)")
endif()

if (MSVC)
    portable_target(COMPILE_OPTIONS ${PROJECT_NAME} "/wd4996")
    portable_target(COMPILE_OPTIONS ${PROJECT_NAME}-static "/wd4996")
endif(MSVC)

if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set_property(TARGET ${PROJECT_NAME}-static PROPERTY POSITION_INDEPENDENT_CODE ON)
endif()