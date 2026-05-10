cmake_minimum_required(VERSION 3.5)

project(sam_api LANGUAGES C VERSION 1.0.0)

set(BUILD_SHARED_LIBS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

file(GLOB_RECURSE sam_src src/*.c)

add_library(${CMAKE_PROJECT_NAME} STATIC sam_api.c ${sam_src})

# add prefix 'sam' to avoid symbol name colision with espeak
target_compile_definitions(${CMAKE_PROJECT_NAME} PUBLIC
    SetSpeed=sam_SetSpeed
    speed=sam_speed)

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE ${PROJECT_SOURCE_DIR} "src")
set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES PUBLIC_HEADER "sam_api.h")

install(TARGETS ${CMAKE_PROJECT_NAME}
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    PUBLIC_HEADER DESTINATION include)
