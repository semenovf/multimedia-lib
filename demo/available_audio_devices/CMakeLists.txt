################################################################################
# Copyright (c) 2021,2022 Vladislav Trifochkin
#
# This file is part of `multimedia-lib`.
#
# Changelog:
#      2021.08.03 Initial version.
################################################################################
project(available_audio_devices)

add_executable(${PROJECT_NAME} main.cpp)
add_executable(${PROJECT_NAME}-static main.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE pfs::multimedia)
target_link_libraries(${PROJECT_NAME}-static PRIVATE pfs::multimedia::static)
