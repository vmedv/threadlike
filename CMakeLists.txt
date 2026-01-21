cmake_minimum_required(VERSION 3.24)

project(threadlike LANGUAGES CXX)

option(USE_ARGOBOTS "use argobots" OFF)
option(USE_FIBERS "use boost::fibers" OFF)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES
    ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES})

add_library(rtw INTERFACE)
target_include_directories(rtw INTERFACE include/)

set_target_properties(rtw PROPERTIES LINKER_LANGUAGE CXX)

add_executable(threadlike src/main.cpp)

target_link_libraries(threadlike PRIVATE rtw)

if (USE_FIBERS)
    # disable warning, everyone use Boost > 1.70
    if(POLICY CMP0167)
        cmake_policy(SET CMP0167 NEW)
    endif()
    find_package(Boost REQUIRED COMPONENTS fiber context)
    target_link_libraries(rtw
        INTERFACE
    Boost::fiber
    Boost::context)
endif()

if (USE_ARGOBOTS)
    # installing argobots to builddir
    set(ABT_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/abt)
    add_custom_command(OUTPUT "${ABT_PREFIX}/include/abt.h"
                    COMMAND /usr/bin/env bash
                        "${CMAKE_CURRENT_SOURCE_DIR}/scripts/abt-install.sh"
                    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                    COMMENT "building argobots"
                    VERBATIM)
    target_include_directories(rtw INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/abt/include/)
    add_custom_target(argobots-build
        DEPENDS ${ABT_PREFIX}/include/abt.h
    )
    add_library(abt STATIC IMPORTED GLOBAL)
    set_target_properties(abt PROPERTIES
        IMPORTED_LOCATION ${ABT_PREFIX}/lib/libabt.a
        INTERFACE_INCLUDE_DIRECTORIES ${ABT_PREFIX}/include
    )

    add_dependencies(abt argobots-build)
    target_link_libraries(rtw INTERFACE abt)
endif()
