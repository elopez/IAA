cmake_minimum_required(VERSION 2.8.11)
project(MachineLearning)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall -Wextra")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11 -lm -Wall -Wextra")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

include_directories(librand)
add_library(librand OBJECT
    librand/librand.cpp
    librand/librand-cpp.cpp
    librand/librand-c.c)

set(TP0_SOURCE_FILES
    TP0/tp0.c)

add_executable(TP0 ${TP0_SOURCE_FILES} $<TARGET_OBJECTS:librand>)
