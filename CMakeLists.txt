##===================================================================================================
##                                 Copyright 2015 Joel Falcou
##
##                   Distributed under the Boost Software License, Version 1.0.
##                        See accompanying file LICENSE.txt or copy at
##                            http://www.boost.org/LICENSE_1_0.txt
##===================================================================================================
cmake_minimum_required(VERSION 2.8.7)

##===================================================================================================
## Setup project
##===================================================================================================
project(STF CXX)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

##===================================================================================================
## Prevent in-source build
##===================================================================================================
if(${PROJECT_SOURCE_DIR} STREQUAL ${PROJECT_BINARY_DIR})
  message( FATAL_ERROR "Building in-source, not recommended! Build in a separate directory." )
endif()

##===================================================================================================
## Search for packages.
##===================================================================================================
find_package(Boost   1.58)
find_package(Doxygen QUIET)

##===================================================================================================
## Install pre-commit git hook
##===================================================================================================
execute_process(COMMAND ${CMAKE_COMMAND} -E copy
                ${PROJECT_SOURCE_DIR}/script/git/pre-commit
                ${PROJECT_SOURCE_DIR}/.git/hooks
               )

##===================================================================================================
## Compute version string and mode
##===================================================================================================
include(parse_revision)

##===================================================================================================
## Add include directories
##===================================================================================================
include_directories(${PROJECT_SOURCE_DIR}/include ${Boost_INCLUDE_DIRS})

##===================================================================================================
## Setup Documentation
##===================================================================================================
add_subdirectory(doc)

##===================================================================================================
## Install target
##===================================================================================================
install ( DIRECTORY ${PROJECT_SOURCE_DIR}/include/stf
          DESTINATION include
        )

##===================================================================================================
## Standalone generator target
##===================================================================================================
add_custom_target(standalone
    COMMAND ${CMAKE_COMMAND} -E remove ${PROJECT_SOURCE_DIR}/standalone/stf.hpp
    COMMAND python ${PROJECT_SOURCE_DIR}/script/embed.py -I include/ --include-match=stf/* include/stf/stf.hpp -o standalone/stf.hpp
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    COMMENT "Building standalone header file"
    VERBATIM
)

##===================================================================================================
## Setup Testing
##===================================================================================================
enable_testing()

##===================================================================================================
## Setup Coverage Test
##===================================================================================================
add_custom_target(tests)
add_custom_target(unit)

include(coverage)
enable_testing()
enable_coverage(stf)
add_dependencies(tests unit)

add_subdirectory(test)

