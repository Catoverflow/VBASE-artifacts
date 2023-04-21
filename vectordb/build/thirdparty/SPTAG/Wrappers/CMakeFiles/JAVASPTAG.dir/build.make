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
include thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/depend.make

# Include the progress variables for this target.
include thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/progress.make

# Include the compile flags for this target's objects.
include thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/flags.make

thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/inc/CoreInterface_jwrap.cpp.o: thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/flags.make
thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/inc/CoreInterface_jwrap.cpp.o: ../thirdparty/SPTAG/Wrappers/inc/CoreInterface_jwrap.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/vectordb/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/inc/CoreInterface_jwrap.cpp.o"
	cd /vectordb/build/thirdparty/SPTAG/Wrappers && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/JAVASPTAG.dir/inc/CoreInterface_jwrap.cpp.o -c /vectordb/thirdparty/SPTAG/Wrappers/inc/CoreInterface_jwrap.cpp

thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/inc/CoreInterface_jwrap.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/JAVASPTAG.dir/inc/CoreInterface_jwrap.cpp.i"
	cd /vectordb/build/thirdparty/SPTAG/Wrappers && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /vectordb/thirdparty/SPTAG/Wrappers/inc/CoreInterface_jwrap.cpp > CMakeFiles/JAVASPTAG.dir/inc/CoreInterface_jwrap.cpp.i

thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/inc/CoreInterface_jwrap.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/JAVASPTAG.dir/inc/CoreInterface_jwrap.cpp.s"
	cd /vectordb/build/thirdparty/SPTAG/Wrappers && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /vectordb/thirdparty/SPTAG/Wrappers/inc/CoreInterface_jwrap.cpp -o CMakeFiles/JAVASPTAG.dir/inc/CoreInterface_jwrap.cpp.s

thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/src/CoreInterface.cpp.o: thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/flags.make
thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/src/CoreInterface.cpp.o: ../thirdparty/SPTAG/Wrappers/src/CoreInterface.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/vectordb/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/src/CoreInterface.cpp.o"
	cd /vectordb/build/thirdparty/SPTAG/Wrappers && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/JAVASPTAG.dir/src/CoreInterface.cpp.o -c /vectordb/thirdparty/SPTAG/Wrappers/src/CoreInterface.cpp

thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/src/CoreInterface.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/JAVASPTAG.dir/src/CoreInterface.cpp.i"
	cd /vectordb/build/thirdparty/SPTAG/Wrappers && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /vectordb/thirdparty/SPTAG/Wrappers/src/CoreInterface.cpp > CMakeFiles/JAVASPTAG.dir/src/CoreInterface.cpp.i

thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/src/CoreInterface.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/JAVASPTAG.dir/src/CoreInterface.cpp.s"
	cd /vectordb/build/thirdparty/SPTAG/Wrappers && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /vectordb/thirdparty/SPTAG/Wrappers/src/CoreInterface.cpp -o CMakeFiles/JAVASPTAG.dir/src/CoreInterface.cpp.s

# Object files for target JAVASPTAG
JAVASPTAG_OBJECTS = \
"CMakeFiles/JAVASPTAG.dir/inc/CoreInterface_jwrap.cpp.o" \
"CMakeFiles/JAVASPTAG.dir/src/CoreInterface.cpp.o"

# External object files for target JAVASPTAG
JAVASPTAG_EXTERNAL_OBJECTS =

../thirdparty/SPTAG/Release/libJAVASPTAG.so: thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/inc/CoreInterface_jwrap.cpp.o
../thirdparty/SPTAG/Release/libJAVASPTAG.so: thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/src/CoreInterface.cpp.o
../thirdparty/SPTAG/Release/libJAVASPTAG.so: thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/build.make
../thirdparty/SPTAG/Release/libJAVASPTAG.so: ../thirdparty/SPTAG/Release/libSPTAGLibStatic.a
../thirdparty/SPTAG/Release/libJAVASPTAG.so: /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/libjawt.so
../thirdparty/SPTAG/Release/libJAVASPTAG.so: /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server/libjvm.so
../thirdparty/SPTAG/Release/libJAVASPTAG.so: ../thirdparty/SPTAG/Release/libDistanceUtils.a
../thirdparty/SPTAG/Release/libJAVASPTAG.so: ../thirdparty/SPTAG/Release/libzstd.a
../thirdparty/SPTAG/Release/libJAVASPTAG.so: thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/vectordb/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX shared library ../../../../thirdparty/SPTAG/Release/libJAVASPTAG.so"
	cd /vectordb/build/thirdparty/SPTAG/Wrappers && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/JAVASPTAG.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/build: ../thirdparty/SPTAG/Release/libJAVASPTAG.so

.PHONY : thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/build

thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/clean:
	cd /vectordb/build/thirdparty/SPTAG/Wrappers && $(CMAKE_COMMAND) -P CMakeFiles/JAVASPTAG.dir/cmake_clean.cmake
.PHONY : thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/clean

thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/depend:
	cd /vectordb/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /vectordb /vectordb/thirdparty/SPTAG/Wrappers /vectordb/build /vectordb/build/thirdparty/SPTAG/Wrappers /vectordb/build/thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : thirdparty/SPTAG/Wrappers/CMakeFiles/JAVASPTAG.dir/depend

