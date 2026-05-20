cmake_minimum_required(VERSION 3.10)
project(mangakolekt_archive_plugin)

# Find libzip properly so CMake knows all its include paths
find_package(PkgConfig REQUIRED)
pkg_check_modules(LIBZIP REQUIRED libzip)

add_library(mangakolekt_archive_lib SHARED
  ../src/mangakolekt_archive_lib.c
)

target_include_directories(mangakolekt_archive_lib PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}/../src
  ${LIBZIP_INCLUDE_DIRS}            # ← adds system libzip paths, includes zipconf.h
)

target_link_libraries(mangakolekt_archive_lib PRIVATE
  ${LIBZIP_LIBRARIES}               # ← links correctly against system libzip
)

add_custom_command(TARGET mangakolekt_archive_lib POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy
    $<TARGET_FILE:mangakolekt_archive_lib>
    ${CMAKE_BINARY_DIR}/libmangakolekt_archive_lib.so
)