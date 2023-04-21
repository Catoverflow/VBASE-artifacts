add_library(testlib
    lib.cpp)

target_include_directories(testlib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
