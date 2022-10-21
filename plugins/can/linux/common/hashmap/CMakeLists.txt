add_library(hashmap "")
set_target_properties(hashmap PROPERTIES LINKER_LANGUAGE CXX)

target_sources(hashmap
  PRIVATE
    hashmap.c
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/hashmap_base.h
    ${CMAKE_CURRENT_LIST_DIR}/hashmap.h
  )

target_include_directories(hashmap
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}
  )
