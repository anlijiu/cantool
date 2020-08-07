cmake_minimum_required(VERSION 3.9)

project(can_plugin)

# add_subdirectory(3rdparty/endian)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN)
#set(CMAKE_CXX_FLAGS "-fsanitize=address")

#set(CMAKE_CXX_FLAGS "-fPIC --std=c++17 -fpermissive -Wall -Wextra -lpthread")
set(NAPI_CPP_EXCEPTIONS "yes")

file(GLOB SOURCE_FILES
        "linux/*.h"
        "linux/*.cc"
        "linux/ammo/*.cc"
        "linux/ammo/*.h"
        "linux/date/*.h"
        )

include_directories(
    ${CMAKE_SOURCE_DIR}/build/linux/can_plugin/flutter/cpp_client_wrapper/include/
    ${CMAKE_SOURCE_DIR}/build/linux/can_plugin/flutter/
    ${CMAKE_SOURCE_DIR}/build
    ${CMAKE_SOURCE_DIR}/linux
    )

add_library(${PROJECT_NAME} SHARED ${SOURCE_FILES})

set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "lib" SUFFIX ".so")

target_include_directories(${PROJECT_NAME} PRIVATE
        ${CMAKE_SOURCE_DIR}/3rdparty/includes
        ${CMAKE_SOURCE_DIR}/linux
)

target_link_libraries(${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/3rdparty/libs/libcontrolcan.so curl)
