# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.14

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/bin/cmake

# The command to remove a file.
RM = /usr/local/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /vectordb

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /vectordb/build

# Utility rule file for clean-all.

# Include the progress variables for this target.
include thirdparty/SPTAG/ThirdParty/zstd/build/cmake/CMakeFiles/clean-all.dir/progress.make

thirdparty/SPTAG/ThirdParty/zstd/build/cmake/CMakeFiles/clean-all:
	cd /vectordb/build/thirdparty/SPTAG/ThirdParty/zstd/build/cmake && /usr/bin/gmake clean
	cd /vectordb/build/thirdparty/SPTAG/ThirdParty/zstd/build/cmake && rm -rf /vectordb/build/

clean-all: thirdparty/SPTAG/ThirdParty/zstd/build/cmake/CMakeFiles/clean-all
clean-all: thirdparty/SPTAG/ThirdParty/zstd/build/cmake/CMakeFiles/clean-all.dir/build.make

.PHONY : clean-all

# Rule to build all files generated by this target.
thirdparty/SPTAG/ThirdParty/zstd/build/cmake/CMakeFiles/clean-all.dir/build: clean-all

.PHONY : thirdparty/SPTAG/ThirdParty/zstd/build/cmake/CMakeFiles/clean-all.dir/build

thirdparty/SPTAG/ThirdParty/zstd/build/cmake/CMakeFiles/clean-all.dir/clean:
	cd /vectordb/build/thirdparty/SPTAG/ThirdParty/zstd/build/cmake && $(CMAKE_COMMAND) -P CMakeFiles/clean-all.dir/cmake_clean.cmake
.PHONY : thirdparty/SPTAG/ThirdParty/zstd/build/cmake/CMakeFiles/clean-all.dir/clean

thirdparty/SPTAG/ThirdParty/zstd/build/cmake/CMakeFiles/clean-all.dir/depend:
	cd /vectordb/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /vectordb /vectordb/thirdparty/SPTAG/ThirdParty/zstd/build/cmake /vectordb/build /vectordb/build/thirdparty/SPTAG/ThirdParty/zstd/build/cmake /vectordb/build/thirdparty/SPTAG/ThirdParty/zstd/build/cmake/CMakeFiles/clean-all.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : thirdparty/SPTAG/ThirdParty/zstd/build/cmake/CMakeFiles/clean-all.dir/depend
