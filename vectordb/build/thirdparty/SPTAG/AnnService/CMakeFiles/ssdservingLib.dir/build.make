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

# Include any dependencies generated for this target.
include thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/depend.make

# Include the progress variables for this target.
include thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/progress.make

# Include the compile flags for this target's objects.
include thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/flags.make

thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/src/SSDServing/main.cpp.o: thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/flags.make
thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/src/SSDServing/main.cpp.o: ../thirdparty/SPTAG/AnnService/src/SSDServing/main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/vectordb/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/src/SSDServing/main.cpp.o"
	cd /vectordb/build/thirdparty/SPTAG/AnnService && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/ssdservingLib.dir/src/SSDServing/main.cpp.o -c /vectordb/thirdparty/SPTAG/AnnService/src/SSDServing/main.cpp

thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/src/SSDServing/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/ssdservingLib.dir/src/SSDServing/main.cpp.i"
	cd /vectordb/build/thirdparty/SPTAG/AnnService && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /vectordb/thirdparty/SPTAG/AnnService/src/SSDServing/main.cpp > CMakeFiles/ssdservingLib.dir/src/SSDServing/main.cpp.i

thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/src/SSDServing/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/ssdservingLib.dir/src/SSDServing/main.cpp.s"
	cd /vectordb/build/thirdparty/SPTAG/AnnService && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /vectordb/thirdparty/SPTAG/AnnService/src/SSDServing/main.cpp -o CMakeFiles/ssdservingLib.dir/src/SSDServing/main.cpp.s

# Object files for target ssdservingLib
ssdservingLib_OBJECTS = \
"CMakeFiles/ssdservingLib.dir/src/SSDServing/main.cpp.o"

# External object files for target ssdservingLib
ssdservingLib_EXTERNAL_OBJECTS =

../thirdparty/SPTAG/Release/libssdservingLib.a: thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/src/SSDServing/main.cpp.o
../thirdparty/SPTAG/Release/libssdservingLib.a: thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/build.make
../thirdparty/SPTAG/Release/libssdservingLib.a: thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/vectordb/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library ../../../../thirdparty/SPTAG/Release/libssdservingLib.a"
	cd /vectordb/build/thirdparty/SPTAG/AnnService && $(CMAKE_COMMAND) -P CMakeFiles/ssdservingLib.dir/cmake_clean_target.cmake
	cd /vectordb/build/thirdparty/SPTAG/AnnService && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/ssdservingLib.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/build: ../thirdparty/SPTAG/Release/libssdservingLib.a

.PHONY : thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/build

thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/clean:
	cd /vectordb/build/thirdparty/SPTAG/AnnService && $(CMAKE_COMMAND) -P CMakeFiles/ssdservingLib.dir/cmake_clean.cmake
.PHONY : thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/clean

thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/depend:
	cd /vectordb/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /vectordb /vectordb/thirdparty/SPTAG/AnnService /vectordb/build /vectordb/build/thirdparty/SPTAG/AnnService /vectordb/build/thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : thirdparty/SPTAG/AnnService/CMakeFiles/ssdservingLib.dir/depend

