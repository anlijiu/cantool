add_library(common "")
set_target_properties(common PROPERTIES LINKER_LANGUAGE C)

add_subdirectory(list)
add_subdirectory(hashmap)
add_subdirectory(queue)

target_sources(common
  PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/thpool.c
    ${CMAKE_CURRENT_LIST_DIR}/thread_pool.c
    ${CMAKE_CURRENT_LIST_DIR}/mpsc.c
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/fmpool.h
    ${CMAKE_CURRENT_LIST_DIR}/thpool.h
    ${CMAKE_CURRENT_LIST_DIR}/thread_pool.h
    ${CMAKE_CURRENT_LIST_DIR}/mpscq.h
  )

target_include_directories(common
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}
  )

target_link_libraries(common
  PRIVATE
    list
    hashmap
    queue
  )
