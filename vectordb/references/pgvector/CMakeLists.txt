cmake_minimum_required(VERSION 3.14.0)
project(vector VERSION 0.1.7)

# Find Dependency

set(PostgreSQL_ADDITIONAL_VERSIONS "13")
find_package(PostgreSQL REQUIRED COMPONENTS Server)

# Add Control and SQL Files

set(EXT_CONTROL_FILE ${PROJECT_NAME}.control)
set(EXT_SQL_FILES
    sql/${PROJECT_NAME}.sql
    sql/vector--0.1.0--0.1.1.sql
    sql/vector--0.1.1--0.1.3.sql
    sql/vector--0.1.3--0.1.4.sql
    sql/vector--0.1.4--0.1.5.sql
    sql/vector--0.1.5--0.1.6.sql
    sql/vector--0.1.6--0.1.7.sql
)

list (GET EXT_SQL_FILES 0 EXT_SQL_MAIN)
configure_file(${EXT_CONTROL_FILE} ${EXT_CONTROL_FILE} COPYONLY)
foreach(EXT_SQL_FILE ${EXT_SQL_FILES})
    configure_file(${EXT_SQL_FILE} ${EXT_SQL_FILE} COPYONLY)
endforeach(EXT_SQL_FILE)

# Add Child Projects

add_subdirectory(lib)

# Add Extension Library

add_library(${PROJECT_NAME} SHARED
    src/cpptest.cpp
    src/ivfbuild.c
    src/ivfflat.c
    src/ivfinsert.c
    src/ivfkmeans.c
    src/ivfscan.c
    src/ivfutils.c
    src/ivfvacuum.c
    src/vector.c
)

target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_17)
set_target_properties(${PROJECT_NAME} PROPERTIES CXX_EXTENSIONS OFF)
target_compile_options(${PROJECT_NAME} PRIVATE -Wall)
set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "")

target_link_libraries(${PROJECT_NAME} PUBLIC PostgreSQL::PostgreSQL testlib)

if(WIN32)
    target_include_directories(${PROJECT_NAME} PUBLIC ${PostgreSQL_TYPE_INCLUDE_DIR}/port/win32)
    target_link_libraries(${PROJECT_NAME} PUBLIC ${PostgreSQL_LIBRARY_DIRS}/postgres.lib)
    if(MSVC)
        target_include_directories(${PROJECT_NAME} PUBLIC ${PostgreSQL_TYPE_INCLUDE_DIR}/port/win32_msvc)
        target_compile_options(${PROJECT_NAME} PRIVATE /TC)
    endif(MSVC)
endif(WIN32)

# Installation Configuration

## Find PostgreSQL Paths

foreach(suffix ${PostgreSQL_KNOWN_VERSIONS})
  if(WIN32)
    list(APPEND PostgreSQL_LIBRARY_ADDITIONAL_SEARCH_SUFFIXES
        "PostgreSQL/${suffix}/bin")
  endif()
  if(UNIX)
    list(APPEND PostgreSQL_LIBRARY_ADDITIONAL_SEARCH_SUFFIXES
        "postgresql${suffix}"
        "postgresql/${suffix}"
        "pgsql-${suffix}/bin")
  endif()
endforeach()
find_program(PostgreSQL_PG_CONFIG pg_config
NAMES ${ARGN}
PATHS
  ${PostgreSQL_ROOT_DIRECTORIES}
PATH_SUFFIXES
  bin
  ${PostgreSQL_BINARY_ADDITIONAL_SEARCH_SUFFIXES}
# Help the user find it if we cannot.
DOC "Set the PostgreSQL_BINARY_DIR cmake cache entry to the top-level directory containing the PostgreSQL binaries."
)
if (NOT PostgreSQL_PG_CONFIG)
    message(FATAL_ERROR "Unable to find 'pg_config'")
endif ()
message(STATUS "Using pg_config ${PostgreSQL_PG_CONFIG}")

execute_process(
        COMMAND ${PostgreSQL_PG_CONFIG} --sharedir
        OUTPUT_VARIABLE PostgreSQL_SHAREDIR
        OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(
        COMMAND ${PostgreSQL_PG_CONFIG} --pkglibdir
        OUTPUT_VARIABLE PostgreSQL_PKGLIBDIR
        OUTPUT_STRIP_TRAILING_WHITESPACE)

## Install Files

install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/${EXT_CONTROL_FILE}
    DESTINATION "${PostgreSQL_SHAREDIR}/extension")
foreach(EXT_SQL_FILE ${EXT_SQL_FILES})
    install(
        FILES ${CMAKE_CURRENT_BINARY_DIR}/${EXT_SQL_FILE}
        DESTINATION "${PostgreSQL_SHAREDIR}/extension")
endforeach(EXT_SQL_FILE)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/${EXT_SQL_MAIN}
    DESTINATION "${PostgreSQL_SHAREDIR}/extension"
    RENAME ${PROJECT_NAME}--${PROJECT_VERSION}.sql)
install(
    TARGETS ${PROJECT_NAME}
    DESTINATION ${PostgreSQL_PKGLIBDIR})
