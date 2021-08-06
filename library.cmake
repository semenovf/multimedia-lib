################################################################################
# Copyright (c) 2021 Vladislav Trifochkin
#
# This file is part of [multimedia-lib](https://github.com/semenovf/multimedia-lib) library.
#
# Changelog:
#      2021.08.03 Initial version.
################################################################################
cmake_minimum_required (VERSION 3.5)
project(multimedia-lib CXX)

option(ENABLE_PULSEAUDIO "Enable PulseAudio as backend" ON)
set(_audio_backend_FOUND OFF)

#if (UNIX AND NOT APPLE AND NOT CYGWIN)
if (${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
    if (ENABLE_PULSEAUDIO)
        # In Ubuntu it is a part of 'libpulse-dev' package
        find_package(PulseAudio)

        if (PULSEAUDIO_FOUND)
            message(STATUS "PulseAudio version: ${PULSEAUDIO_VERSION}")

            list(APPEND SOURCES
                ${CMAKE_CURRENT_LIST_DIR}/src/device_info_pulseaudio.cpp)
            set(_audio_backend_FOUND ON)
        endif()
    endif()
endif()

if (NOT _audio_backend_FOUND)
    message(FATAL_ERROR
        " No any Audio backend found\n"
        " For Debian-based distributions it may be PulseAudio ('libpulse-dev' package)"
    )
endif()

# if (UNIX)
#     list(APPEND SOURCES
#         ${CMAKE_CURRENT_LIST_DIR}/src/network_interface.cpp
#         ${CMAKE_CURRENT_LIST_DIR}/src/network_interface_linux.cpp)
# elseif (MSVC)
#     list(APPEND SOURCES
#         ${CMAKE_CURRENT_LIST_DIR}/src/network_interface.cpp
#         ${CMAKE_CURRENT_LIST_DIR}/src/network_interface_win32.cpp)
# else()
#     message (FATAL_ERROR "Unsupported platform")
# endif()

# Make object files for STATIC and SHARED targets
add_library(${PROJECT_NAME}_OBJLIB OBJECT ${SOURCES})

add_library(${PROJECT_NAME} SHARED $<TARGET_OBJECTS:${PROJECT_NAME}_OBJLIB>)
add_library(${PROJECT_NAME}-static STATIC $<TARGET_OBJECTS:${PROJECT_NAME}_OBJLIB>)
add_library(pfs::multimedia ALIAS ${PROJECT_NAME})
add_library(pfs::multimedia::static ALIAS ${PROJECT_NAME}-static)

target_include_directories(${PROJECT_NAME}_OBJLIB PRIVATE ${CMAKE_CURRENT_LIST_DIR}/include)
target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_LIST_DIR}/include)
target_include_directories(${PROJECT_NAME}-static PUBLIC ${CMAKE_CURRENT_LIST_DIR}/include)

if (PulseAudio_FOUND)
    target_include_directories(${PROJECT_NAME}_OBJLIB PRIVATE ${PULSEAUDIO_INCLUDE_DIR})
    target_include_directories(${PROJECT_NAME} PUBLIC ${PULSEAUDIO_INCLUDE_DIR})
    target_include_directories(${PROJECT_NAME}-static PUBLIC ${PULSEAUDIO_INCLUDE_DIR})

    target_link_libraries(${PROJECT_NAME}_OBJLIB PRIVATE ${PULSEAUDIO_LIBRARY})
    target_link_libraries(${PROJECT_NAME} PUBLIC ${PULSEAUDIO_LIBRARY})
    target_link_libraries(${PROJECT_NAME}-static PUBLIC ${PULSEAUDIO_LIBRARY})

    target_compile_definitions(${PROJECT_NAME}_OBJLIB PRIVATE -DPFS_PULSE_AUDIO_PLATFORM=1)
endif(PulseAudio_FOUND)

# Shared libraries need PIC
# For SHARED and MODULE libraries the POSITION_INDEPENDENT_CODE target property
# is set to ON automatically, but need for OBJECT type
set_property(TARGET ${PROJECT_NAME}_OBJLIB PROPERTY POSITION_INDEPENDENT_CODE ON)

# target_link_libraries(${PROJECT_NAME}_OBJLIB PRIVATE pfs::common)
# target_link_libraries(${PROJECT_NAME} PUBLIC pfs::common)
# target_link_libraries(${PROJECT_NAME}-static PUBLIC pfs::common)

if (MSVC)
    # Important! For compatiblity between STATIC and SHARED libraries
    target_compile_definitions(${PROJECT_NAME}_OBJLIB PRIVATE -DPFS_MULTIMEDIA_DLL_EXPORTS)

    target_compile_definitions(${PROJECT_NAME} PUBLIC -DPFS_MULTIMEDIA_DLL_EXPORTS -DUNICODE -D_UNICODE)
    target_compile_definitions(${PROJECT_NAME}-static PUBLIC -DPFS_MULTIMEDIA_STATIC_LIB -DUNICODE -D_UNICODE)
#     target_link_libraries(${PROJECT_NAME} PRIVATE Ws2_32 Iphlpapi)
#     target_link_libraries(${PROJECT_NAME}-static PRIVATE Ws2_32 Iphlpapi)
endif(MSVC)
