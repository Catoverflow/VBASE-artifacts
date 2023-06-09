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

# Utility rule file for zstdcat.

# Include the progress variables for this target.
include thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/zstdcat.dir/progress.make

thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/zstdcat: ../thirdparty/SPTAG/Release/zstd
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/vectordb/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Creating zstdcat symlink"
	cd /vectordb/build/thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs && /usr/local/bin/cmake -E create_symlink zstd zstdcat

zstdcat: thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/zstdcat
zstdcat: thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/zstdcat.dir/build.make

.PHONY : zstdcat

# Rule to build all files generated by this target.
thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/zstdcat.dir/build: zstdcat

.PHONY : thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/zstdcat.dir/build

thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/zstdcat.dir/clean:
	cd /vectordb/build/thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs && $(CMAKE_COMMAND) -P CMakeFiles/zstdcat.dir/cmake_clean.cmake
.PHONY : thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/zstdcat.dir/clean

thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/zstdcat.dir/depend:
	cd /vectordb/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /vectordb /vectordb/thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs /vectordb/build /vectordb/build/thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs /vectordb/build/thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/zstdcat.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/zstdcat.dir/depend

