cmake_minimum_required(VERSION 3.14)

set(CMAKE_VERBOSE_MAKEFILE off)

project(
    piper_phonemize
    VERSION 1.1.0
    DESCRIPTION "Phonemization library for Piper text to speech system"
    HOMEPAGE_URL "https://github.com/rhasspy/piper-phonemize"
    LANGUAGES CXX
)

string(APPEND CMAKE_CXX_FLAGS " -Wall -Wextra -Wl,-rpath,'$ORIGIN'")
string(APPEND CMAKE_C_FLAGS " -Wall -Wextra")

# ---- espeak-ng ---

find_package(PkgConfig)
pkg_check_modules(ESPEAK_NG REQUIRED espeak-ng<2)

# ---- onnxruntime ---

find_library(onnxruntime_path onnxruntime REQUIRED)

# ---- Declare library ----

add_library(
    piper_phonemize
    src/phonemize.cpp
    src/phoneme_ids.cpp
    src/tashkeel.cpp
)

set_target_properties(piper_phonemize PROPERTIES
    VERSION ${PROJECT_VERSION}
    SOVERSION ${PROJECT_VERSION_MAJOR})

target_include_directories(
    piper_phonemize PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src>"
    ${ESPEAK_NG_INCLUDE_DIRS}
)

target_link_directories(
    piper_phonemize PUBLIC
    ${ESPEAK_NG_LIBRARY_DIRS}

)

target_link_libraries(
    piper_phonemize
    ${ESPEAK_NG_LIBRARIES}
    ${onnxruntime_path}
)

target_compile_options(
    piper_phonemize PUBLIC
    ${ESPEAK_NG_CFLAGS_OTHER}
)

target_compile_features(piper_phonemize PUBLIC cxx_std_17)

install(
    TARGETS piper_phonemize
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)

install(
    DIRECTORY ${CMAKE_SOURCE_DIR}/src/
    DESTINATION include/piper-phonemize
    FILES_MATCHING
    PATTERN "*.h"
    PATTERN "*.hpp")
