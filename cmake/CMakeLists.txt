cmake_minimum_required(VERSION 3.10)

project(Example VERSION 1.0)

add_executable(example example.cxx)

enable_testing()
add_test(NAME test COMMAND $<TARGET_FILE:example>)

# Make sure MSYS, CYGWIN, MINGW, WIN32 are defined correctly.
if(NOT CMAKE_CROSSCOMPILING)
    set(MSYSTEM $ENV{MSYSTEM})
    if(MSYSTEM STREQUAL "MSYS" OR MSYSTEM STREQUAL "CYGWIN")
        if(NOT MSYS OR NOT CYGWIN OR WIN32 OR MINGW)
            message(FATAL_ERROR "broken")
        endif()
    else()
        if(NOT MINGW OR NOT WIN32 OR CYGWIN)
            message(FATAL_ERROR "broken")
        endif()
        if (CMAKE_GENERATOR STREQUAL "MSYS Makefiles" AND NOT MSYS)
            message(FATAL_ERROR "broken")
        endif()
        if (NOT (CMAKE_GENERATOR STREQUAL "MSYS Makefiles") AND MSYS)
            message(FATAL_ERROR "broken")
        endif()
    endif()
endif()