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

# Utility rule file for unzstd.

# Include the progress variables for this target.
include thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/unzstd.dir/progress.make

thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/unzstd: ../thirdparty/SPTAG/Release/zstd
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/vectordb/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Creating unzstd symlink"
	cd /vectordb/build/thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs && /usr/local/bin/cmake -E create_symlink zstd unzstd

unzstd: thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/unzstd
unzstd: thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/unzstd.dir/build.make

.PHONY : unzstd

# Rule to build all files generated by this target.
thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/unzstd.dir/build: unzstd

.PHONY : thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/unzstd.dir/build

thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/unzstd.dir/clean:
	cd /vectordb/build/thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs && $(CMAKE_COMMAND) -P CMakeFiles/unzstd.dir/cmake_clean.cmake
.PHONY : thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/unzstd.dir/clean

thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/unzstd.dir/depend:
	cd /vectordb/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /vectordb /vectordb/thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs /vectordb/build /vectordb/build/thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs /vectordb/build/thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/unzstd.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : thirdparty/SPTAG/ThirdParty/zstd/build/cmake/programs/CMakeFiles/unzstd.dir/depend

