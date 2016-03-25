cmake_minimum_required(VERSION 3.4)
project(MachineLearning)

set(CMAKE_C_FLAGS "${CMAKE_CXX_FLAGS} -std=c11 -lm")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

set(TP0_SOURCE_FILES
    TP0/tp0.c)

add_executable(TP0 ${TP0_SOURCE_FILES})