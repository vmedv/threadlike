cmake_minimum_required(VERSION 3.24)

project(threadlike LANGUAGES CXX)

option(ARGOBOTS_PATH "path to argobots installation" "")

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")

if(CMAKE_EXPORT_COMPILE_COMMANDS)
    set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES
      ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES})
endif()

add_executable(threadlike src/main.cpp)

find_package(Boost REQUIRED COMPONENTS fiber)

target_link_libraries(threadlike
    Boost::fiber
    Boost::context
    ${Boost_LIBRARIES}
)

if (NOT ARGOBOTS_PATH STREQUAL "")
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(ARGOBOTS REQUIRED IMPORTED_TARGET
                  "${ARGOBOTS_PATH}/lib/pkgconfig/argobots.pc")
    target_include_directories(threadlike PRIVATE ${ARGOBOTS_INCLUDE_DIRS})
    target_link_libraries(threadlike PkgConfig::ARGOBOTS)
endif()
