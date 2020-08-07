# Install script for directory: /home/anlijiu/disk/workspace/flutter/cantool/linux

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xRuntimex" OR NOT CMAKE_INSTALL_COMPONENT)
  
  file(REMOVE_RECURSE "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/")
  
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xRuntimex" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/cantool" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/cantool")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/cantool"
         RPATH "$ORIGIN/lib")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/cantool")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle" TYPE EXECUTABLE FILES "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/cantool")
  if(EXISTS "$ENV{DESTDIR}/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/cantool" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/cantool")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/cantool"
         OLD_RPATH "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/plugins/color_panel:/home/anlijiu/disk/workspace/flutter/cantool/linux/build/plugins/file_chooser:/home/anlijiu/disk/workspace/flutter/cantool/linux/build/plugins/menubar:/home/anlijiu/disk/workspace/flutter/cantool/linux/build/plugins/window_size:/home/anlijiu/disk/workspace/flutter/cantool/linux/flutter/ephemeral:"
         NEW_RPATH "$ORIGIN/lib")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/cantool")
    endif()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xRuntimex" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/data/icudtl.dat")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/data" TYPE FILE FILES "/home/anlijiu/disk/workspace/flutter/cantool/linux/flutter/ephemeral/icudtl.dat")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xRuntimex" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/lib/libflutter_linux_gtk.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/lib" TYPE FILE FILES "/home/anlijiu/disk/workspace/flutter/cantool/linux/flutter/ephemeral/libflutter_linux_gtk.so")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xRuntimex" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/lib/libcolor_panel_plugin.so;/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/lib/libfile_chooser_plugin.so;/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/lib/libmenubar_plugin.so;/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/lib/libwindow_size_plugin.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/lib" TYPE FILE FILES
    "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/plugins/color_panel/libcolor_panel_plugin.so"
    "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/plugins/file_chooser/libfile_chooser_plugin.so"
    "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/plugins/menubar/libmenubar_plugin.so"
    "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/plugins/window_size/libwindow_size_plugin.so"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xRuntimex" OR NOT CMAKE_INSTALL_COMPONENT)
  
  file(REMOVE_RECURSE "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/data/flutter_assets")
  
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xRuntimex" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/data/flutter_assets")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/bundle/data" TYPE DIRECTORY FILES "/home/anlijiu/disk/workspace/flutter/cantool/build//flutter_assets")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/anlijiu/disk/workspace/flutter/cantool/linux/build/flutter/cmake_install.cmake")
  include("/home/anlijiu/disk/workspace/flutter/cantool/linux/build/plugins/color_panel/cmake_install.cmake")
  include("/home/anlijiu/disk/workspace/flutter/cantool/linux/build/plugins/file_chooser/cmake_install.cmake")
  include("/home/anlijiu/disk/workspace/flutter/cantool/linux/build/plugins/menubar/cmake_install.cmake")
  include("/home/anlijiu/disk/workspace/flutter/cantool/linux/build/plugins/window_size/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/anlijiu/disk/workspace/flutter/cantool/linux/build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
