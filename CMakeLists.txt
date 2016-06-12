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

# TP2 tools
add_executable(bp TP2/bp.c)
add_executable(discretiza TP2/discretiza.c)
add_executable(separa_clases TP2/separa_clases.c)

# TP3 tools
set(TP3_SOURCE_FILES
    TP3/naivebayes.cpp
    TP3/histogram.cpp)

# TP3 - Naive Bayes with normal approx
add_executable(naivebayes.normal ${TP3_SOURCE_FILES})

# TP3 - Naive Bayes with histogram approx
add_executable(naivebayes.hist ${TP3_SOURCE_FILES})
target_compile_options(naivebayes.hist PRIVATE -DUSE_HIST)

# TP3 - Naive Bayes with histogram approx and m-estimation
add_executable(naivebayes.hist.m ${TP3_SOURCE_FILES})
target_compile_options(naivebayes.hist.m PRIVATE -DUSE_HIST -DUSE_M_ESTIMATE)