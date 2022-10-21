add_library(module "")
set_target_properties(module PROPERTIES LINKER_LANGUAGE C)

target_sources(module
  PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/bus.c
    ${CMAKE_CURRENT_LIST_DIR}/device.c
    ${CMAKE_CURRENT_LIST_DIR}/module.c

  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/bus.h
    ${CMAKE_CURRENT_LIST_DIR}/can_defs.h
    ${CMAKE_CURRENT_LIST_DIR}/compiler_attributes.h
    ${CMAKE_CURRENT_LIST_DIR}/device.h
    ${CMAKE_CURRENT_LIST_DIR}/module.h
  )

target_include_directories(module
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}
  )

target_link_libraries(module
  # INTERFACE
  #   common
  PUBLIC
    common
    ${LIBUSB_LIBRARIES}
  # PRIVATE
)
