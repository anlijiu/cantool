# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.23)

# Project-level configuration.
set(PLUGIN_NAME "can_plugin")
project(${PLUGIN_NAME} LANGUAGES C)

set(CMAKE_VERBOSE_MAKEFILE on)
# set(CMAKE_BUILD_TYPE RelWithDebInfo)
set(CMAKE_BUILD_TYPE ASAN)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")

set(CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
FIND_PACKAGE(PkgConfig REQUIRED) #想用pkg相关命令需要先引入这个 
find_package(ZLIB)
find_package(Iconv)
find_package(LibUSB)
find_package(LibFFI REQUIRED)

include_directories(${LIBUSB_INCLUDE_DIR})
include_directories(${THIRD_PARTY_INCLUDE_DIR})

set(DRIVERS_LOCATION "drivers")

add_subdirectory(common)
add_subdirectory(module)
add_subdirectory(main)

add_subdirectory(usbcanii)
add_subdirectory(tsmaster)

# Apply a standard set of build settings that are configured in the
# application-level CMakeLists.txt. This can be removed for plugins that want
# full control over build settings.
apply_standard_settings(${PLUGIN_NAME})


target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")

# Source include directories and library dependencies. Add any plugin-specific
# dependencies here.
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::GTK)
target_link_libraries(${PLUGIN_NAME} PRIVATE ZLIB::ZLIB)
target_link_libraries(${PLUGIN_NAME} PRIVATE Iconv::Iconv)

# Symbols are hidden by default to reduce the chance of accidental conflicts
# between plugins. This should not be removed; any symbols that should be
# exported should be explicitly exported with the FLUTTER_PLUGIN_EXPORT macro.
# set_target_properties(${PLUGIN_NAME} PROPERTIES
#   CXX_VISIBILITY_PRESET hidden)

# set_target_properties(${PLUGIN_NAME} PROPERTIES LINK_FLAGS "-Wl,-rpath,./,-rpath,./lib,--enable-new-dtags")

# # 安装动态库的目标目录
# set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}")
# 
# # 安装动态库，到执行目录
# install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/libs/libcontrolcan.so" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
#   COMPONENT Runtime)
# install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/libs/libcandbc.so.0" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
#   COMPONENT Runtime)
# install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/libs/libusb-1.0.so.0" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
#   COMPONENT Runtime)
# 
# target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
# 
# # Source include directories and library dependencies. Add any plugin-specific
# # dependencies here.
# target_include_directories(${PLUGIN_NAME} INTERFACE
#   "${CMAKE_CURRENT_SOURCE_DIR}/include")
# target_link_libraries(${PLUGIN_NAME} PRIVATE flutter)
# target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::GTK)
# target_link_libraries(${PLUGIN_NAME} PRIVATE ZLIB::ZLIB)
# target_link_libraries(${PLUGIN_NAME} PRIVATE Iconv::Iconv)
# # target_link_libraries(${PLUGIN_NAME} PRIVATE libcontrolcan)
# target_link_libraries(${PLUGIN_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/libs/libcontrolcan.so)
# target_link_libraries(${PLUGIN_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/libs/libcandbc.so.0)
# target_link_libraries(${PLUGIN_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/libs/libusb-1.0.so.0)
# 
# # List of absolute paths to libraries that should be bundled with the plugin.
# # This list could contain prebuilt libraries, or libraries created by an
# # external build triggered from this build file.
set(can_bundled_libraries
  ""
  PARENT_SCOPE
)
# 
