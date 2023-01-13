
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib")
message("main cmake , INSTALL_BUNDLE_LIB_DIR: ${INSTALL_BUNDLE_LIB_DIR}")

add_library(candbc SHARED IMPORTED GLOBAL)

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bundle)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bundle)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bundle)

set_target_properties(candbc PROPERTIES
    # LINKER_LANGUAGE C
    INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty
    IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/libcandbc.so.0
    IMPORTED_LOCATION_DEBUG ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/libcandbc.so.0
    LIBRARY_OUTPUT_DIRECTORY  ${INSTALL_BUNDLE_LIB_DIR}/
    RUNTIME_OUTPUT_DIRECTORY ${INSTALL_BUNDLE_LIB_DIR}/
    ARCHIVE_OUTPUT_DIRECTORY ${INSTALL_BUNDLE_LIB_DIR}/
    IMPORTED_SONAME libcandbc.so.0
    )

add_library(${PLUGIN_NAME} SHARED
    can_plugin.c
    # app.c
    driver_manage.c
    replay_operator.c
    can_operator.c
    frame_to_flvalue.c
    dbc_parser.c
    libwecan.c
    asc/asc_reader.c
    blf/blfapi.c
    blf/blfparser.c
    blf/blfreader.c
    blf/blfstream.c
)

include_directories(asc blf)
# add_subdirectory(asc)
# add_subdirectory(blf)


set_target_properties(${PLUGIN_NAME} PROPERTIES
  LINKER_LANGUAGE C
  BUILD_WITH_INSTALL_RPATH FALSE
  INSTALL_RPATH "\$ORIGIN/../drivers/lib"
  LINK_FLAGS "-Wl,-export-dynamic,--disable-new-dtags"
)

install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/libcandbc.so.0" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)

# add_custom_command(TARGET ${PLUGIN_NAME} POST_BUILD
#     COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/libcandbc.so.0 ${INSTALL_BUNDLE_LIB_DIR}/libcandbc.so.0
# )

# 检测内存泄露 sanitize
# target_compile_options(${PLUGIN_NAME} PRIVATE -fsanitize=address)
# target_link_options(${PLUGIN_NAME} PRIVATE -fsanitize=address)

target_include_directories(${PLUGIN_NAME}
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}
    ${CMAKE_CURRENT_LIST_DIR}/../include
    ${CMAKE_CURRENT_LIST_DIR}/3rdparty
  )

target_link_libraries(${PLUGIN_NAME}
  PUBLIC
    ${CMAKE_DL_LIBS}
    ${LIBUSB_LIBRARIES}
    candbc
  PRIVATE
    common
    module
  )


