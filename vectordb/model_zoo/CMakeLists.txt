cmake_minimum_required(VERSION 3.0)
include(FindPkgConfig)
pkg_check_modules(CURLPP REQUIRED curlpp)

set(CMAKE_CXX_STANDARD 11) # C++11...
set(CMAKE_CXX_STANDARD_REQUIRED ON) #...is required...
set(CMAKE_CXX_EXTENSIONS OFF) #...without compiler extensions like gnu++11


# SET(mylibSRCS lib.c)
# file(GLOB FileList "*.cpp")
# SET(libsrc word2vec.cpp
  

SET(testsrc modeltest.cpp)

ADD_LIBRARY(modelzoo SHARED
  util.cpp
  word2vec.cpp
  img2vec.cpp
  )
TARGET_LINK_LIBRARIES(modelzoo curlpp)

ADD_EXECUTABLE(modeltest modeltest.cpp)
TARGET_LINK_LIBRARIES(modeltest modelzoo)

install(
    TARGETS modelzoo
    DESTINATION /usr/lib)


# file(GLOB ExamplesFileList "*.cpp")

# # Create a meta target to create examples
# add_custom_target(build_all_examples COMMENT A target that requires all the examples.)

# message(STATUS "Creating build rules for Examples:")
# foreach(Example ${ExamplesFileList})
#   message(STATUS "\tCreating build rule for ${Example}")
#   # Get the name without extension or directory
#   get_filename_component(ExampleName ${Example} NAME_WE)
#   # Define example executable
#   add_executable(${ExampleName} ${Example})
#   # Link example against curlpp
#   target_link_libraries(${ExampleName} ${CURLPP_LDFLAGS})
#   # make the meta target depend on this example.
#   add_dependencies(build_all_examples ${ExampleName})
# endforeach(Example ${ExamplesFileList})
