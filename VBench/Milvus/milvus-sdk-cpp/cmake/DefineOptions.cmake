# Licensed to the LF AI & Data foundation under one
# or more contributor license agreements. See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership. The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

macro(set_option_category name)
    set(MILVUS_OPTION_CATEGORY ${name})
    list(APPEND "MILVUS_OPTION_CATEGORIES" ${name})
endmacro()

macro(define_option name description default)
    option(${name} ${description} ${default})
    list(APPEND "MILVUS_${MILVUS_OPTION_CATEGORY}_OPTION_NAMES" ${name})
    set("${name}_OPTION_DESCRIPTION" ${description})
    set("${name}_OPTION_DEFAULT" ${default})
    set("${name}_OPTION_TYPE" "bool")
endmacro()

function(list_join lst glue out)
    if ("${${lst}}" STREQUAL "")
        set(${out} "" PARENT_SCOPE)
        return()
    endif ()

    list(GET ${lst} 0 joined)
    list(REMOVE_AT ${lst} 0)
    foreach (item ${${lst}})
        set(joined "${joined}${glue}${item}")
    endforeach ()
    set(${out} ${joined} PARENT_SCOPE)
endfunction()

macro(define_option_string name description default)
    set(${name} ${default} CACHE STRING ${description})
    list(APPEND "MILVUS_${MILVUS_OPTION_CATEGORY}_OPTION_NAMES" ${name})
    set("${name}_OPTION_DESCRIPTION" ${description})
    set("${name}_OPTION_DEFAULT" "\"${default}\"")
    set("${name}_OPTION_TYPE" "string")

    set("${name}_OPTION_ENUM" ${ARGN})
    list_join("${name}_OPTION_ENUM" "|" "${name}_OPTION_ENUM")
    if (NOT ("${${name}_OPTION_ENUM}" STREQUAL ""))
        set_property(CACHE ${name} PROPERTY STRINGS ${ARGN})
    endif ()
endmacro()

#----------------------------------------------------------------------
set_option_category("Milvus Build Option")

define_option(BUILD_TEST "Build with testing" OFF)
define_option(BUILD_COVERAGE "Build with coverage" OFF)
define_option(BUILD_SHARED "Build with shared" ON)
define_option(BUILD_STATIC "Build with static" OFF)

# options for package
define_option_string(MILVUS_SDK_VERSION
    "Version for sdk"
    "2.0.0")
define_option_string(MILVUS_SDK_RELEASE
    "Release number for sdk"
    "1")

#----------------------------------------------------------------------
set_option_category("Thirdparty")

set(MILVUS_DEPENDENCY_SOURCE_DEFAULT "BUNDLED")

define_option_string(MILVUS_DEPENDENCY_SOURCE
        "Method to use for acquiring MILVUS's build dependencies"
        "${MILVUS_DEPENDENCY_SOURCE_DEFAULT}"
        "AUTO"
        "BUNDLED"
        "SYSTEM")

define_option(MILVUS_WITH_GRPC "Build with GRPC" ON)

define_option(MILVUS_WITH_ZLIB "Build with zlib compression" ON)

define_option(MILVUS_VERBOSE_THIRDPARTY_BUILD
        "Show output from ExternalProjects rather than just logging to files" ON)

#----------------------------------------------------------------------
macro(config_summary)
    message(STATUS "---------------------------------------------------------------------")
    message(STATUS)
    message(STATUS "Build configuration summary:")

    message(STATUS "  Generator: ${CMAKE_GENERATOR}")
    message(STATUS "  Build type: ${CMAKE_BUILD_TYPE}")
    message(STATUS "  Source directory: ${CMAKE_CURRENT_SOURCE_DIR}")
    if (${CMAKE_EXPORT_COMPILE_COMMANDS})
        message(
                STATUS "  Compile commands: ${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json")
    endif ()

    foreach (category ${MILVUS_OPTION_CATEGORIES})

        message(STATUS)
        message(STATUS "${category} options:")

        set(option_names ${MILVUS_${category}_OPTION_NAMES})

        set(max_value_length 0)
        foreach (name ${option_names})
            string(LENGTH "\"${${name}}\"" value_length)
            if (${max_value_length} LESS ${value_length})
                set(max_value_length ${value_length})
            endif ()
        endforeach ()

        foreach (name ${option_names})
            if ("${${name}_OPTION_TYPE}" STREQUAL "string")
                set(value "\"${${name}}\"")
            else ()
                set(value "${${name}}")
            endif ()

            set(default ${${name}_OPTION_DEFAULT})
            set(description ${${name}_OPTION_DESCRIPTION})
            string(LENGTH ${description} description_length)
            if (${description_length} LESS 70)
                string(
                        SUBSTRING
                        "                                                                     "
                        ${description_length} -1 description_padding)
            else ()
                set(description_padding "
                ")
            endif ()

            set(comment "[${name}]")

            if ("${value}" STREQUAL "${default}")
                set(comment "[default] ${comment}")
            endif ()

            if (NOT ("${${name}_OPTION_ENUM}" STREQUAL ""))
                set(comment "${comment} [${${name}_OPTION_ENUM}]")
            endif ()

            string(
                    SUBSTRING "${value}                                                             "
                    0 ${max_value_length} value)

            message(STATUS "  ${description} ${description_padding} ${value} ${comment}")
        endforeach ()

    endforeach ()

endmacro()
