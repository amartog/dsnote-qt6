cmake_minimum_required(VERSION 3.13)
project(vosk-api CXX)

set(CMAKE_CXX_STANDARD 17)

set(lib_dir "${CMAKE_LIBRARY_PATH}")
set(include_dir "${CMAKE_INCLUDE_PATH}")

set(static_dep_libs
  "${lib_dir}/libkaldi-online2.a"
  "${lib_dir}/libkaldi-decoder.a"
  "${lib_dir}/libkaldi-ivector.a"
  "${lib_dir}/libkaldi-gmm.a"
  "${lib_dir}/libkaldi-tree.a"
  "${lib_dir}/libkaldi-feat.a"
  "${lib_dir}/libkaldi-lat.a"
  "${lib_dir}/libkaldi-lm.a"
  "${lib_dir}/libkaldi-rnnlm.a"
  "${lib_dir}/libkaldi-hmm.a"
  "${lib_dir}/libkaldi-nnet3.a"
  "${lib_dir}/libkaldi-transform.a"
  "${lib_dir}/libkaldi-cudamatrix.a"
  "${lib_dir}/libkaldi-matrix.a"
  "${lib_dir}/libkaldi-fstext.a"
  "${lib_dir}/libkaldi-util.a"
  "${lib_dir}/libkaldi-base.a"
  "${lib_dir}/libfst.a"
  "${lib_dir}/libfstngram.a")

find_library(openblas_path NAME openblas REQUIRED)
set(shared_dep_libs ${openblas_path})

add_library(vosk SHARED
  src/language_model.cc
  src/model.cc
  src/recognizer.cc
  src/spk_model.cc
  src/vosk_api.cc
)

target_link_libraries(vosk PRIVATE ${static_dep_libs} ${shared_dep_libs})
target_include_directories(vosk PRIVATE ${include_dir} ${include_dir}/kaldi)

include(GNUInstallDirs)
install(TARGETS vosk DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(FILES src/vosk_api.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
