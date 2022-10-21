add_library(usbcanii MODULE)
set_target_properties(usbcanii PROPERTIES LINKER_LANGUAGE C)

set(INSTALL_DRIVER_DIR "${CMAKE_INSTALL_PREFIX}/${DRIVERS_LOCATION}")
set(INSTALL_DRIVER_LIB_DIR "${INSTALL_DRIVER_DIR}/lib")


set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bundle)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bundle)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bundle)


set_target_properties(usbcanii PROPERTIES
  BUILD_WITH_INSTALL_RPATH TRUE
  # LINK_FLAGS "-Wl,-rpath,./lib,--enable-new-dtags"
  # LINK_FLAGS "-Wl,-rpath,./drivers,--enable-new-dtags"
  # LIBRARY_OUTPUT_DIRECTORY "${INSTALL_DRIVER_DIR}/"
)

add_library(controlcan SHARED IMPORTED)
set_target_properties(controlcan PROPERTIES
    IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/libcontrolcan.so
    IMPORTED_LOCATION_DEBUG ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/libcontrolcan.so
    LIBRARY_OUTPUT_DIRECTORY  ${INSTALL_DRIVER_LIB_DIR}
    RUNTIME_OUTPUT_DIRECTORY "$<CONFIG>/controlcan"
    ARCHIVE_OUTPUT_DIRECTORY "$<CONFIG>/controlcan"
    IMPORTED_NO_SONAME TRUE
    )

# add_custom_command(TARGET usbcanii  POST_BUILD
#     COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/libcontrolcan.so ${INSTALL_DRIVER_LIB_DIR}/libcontrolcan.so 
# )

install(TARGETS usbcanii DESTINATION "${INSTALL_DRIVER_DIR}" COMPONENT Runtime)
install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/libcontrolcan.so" DESTINATION "${INSTALL_DRIVER_LIB_DIR}" COMPONENT Runtime)



target_sources(usbcanii
  PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/usbcanii.c

  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/usbcanii.h
  )

target_include_directories(usbcanii
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}
    ${CMAKE_CURRENT_LIST_DIR}/3rdparty
  )

target_link_libraries(usbcanii
  # INTERFACE 
  #   controlcan
  PUBLIC
    module
    controlcan
  # PRIVATE
  #   controlcan
)

# set_property(TARGET usbcanii PROPERTY IMPORTED_LINK_DEPENDENT_LIBRARIES controlcan)
