cmake_minimum_required(VERSION 3.10)
set(PROJECT_NAME "can")
project(${PROJECT_NAME} LANGUAGES CXX)

set(PLUGIN_NAME "${PROJECT_NAME}_plugin")

# set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")
# set(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)
set(CMAKE_SKIP_BUILD_RPATH FALSE)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE) 
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)
set(CMAKE_INSTALL_RPATH "")
SET(CMAKE_INSTALL_RPATH "\${ORIGIN}/../lib")
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib")

ADD_DEFINITIONS(
  -Wno-unused-function
)
find_package(ZLIB)
find_package(Iconv)

add_library(${PLUGIN_NAME} SHARED
  "${PLUGIN_NAME}.cc"
  "can_device.cc"
  "can_operator.cc"
  "replay_operator.cc"
  "cstr.cc"
  "hashmap.cc"
  "libwecan.cc"
  "pipe.c"
  "list/list.cc"
  "list/list_node.cc"
  "list/list_iterator.cc"
  "asc/asc_reader.cc"
  "blf/blfapi.cc"
  "blf/blfparser.cc"
  "blf/blfreader.cc"
  "blf/blfstream.cc"
  "dbc_parser.cc"
)
include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}/include
  ${CMAKE_CURRENT_SOURCE_DIR}/list
  ${CMAKE_CURRENT_SOURCE_DIR}/blf
  ${CMAKE_CURRENT_SOURCE_DIR}/asc
  ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/includes
)

message("hello")
message(${CMAKE_CURRENT_SOURCE_DIR})
message(${CMAKE_BINARY_DIR})
apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden
  C_STANDARD 11)
set_target_properties(${PLUGIN_NAME} PROPERTIES LINK_FLAGS "-Wl,-rpath,./,-rpath,./lib,--enable-new-dtags")


install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/libs/libcontrolcan.so" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)
install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/libs/libcandbc.so.0" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)
install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/libs/libusb-1.0.so.0" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)


message(flutter)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE ZLIB::ZLIB)
target_link_libraries(${PLUGIN_NAME} PRIVATE Iconv::Iconv)
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::GTK)
# target_link_libraries(${PLUGIN_NAME} PRIVATE libcontrolcan)
target_link_libraries(${PLUGIN_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/libs/libcontrolcan.so)
target_link_libraries(${PLUGIN_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/libs/libcandbc.so.0)
target_link_libraries(${PLUGIN_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/libs/libusb-1.0.so.0)

