add_library(queue "")

target_sources(queue
  PRIVATE
    queue.c
    queue_internal.c
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/queue.h
    ${CMAKE_CURRENT_LIST_DIR}/queue_internal.h
  )

target_include_directories(queue
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}
  )
