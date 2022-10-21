add_library(list "")
set_target_properties(list PROPERTIES LINKER_LANGUAGE CXX)

target_sources(list
  PRIVATE
    list.c
    list_node.c
    list_iterator.c  
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/list.h
  )

target_include_directories(list
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}
  )
