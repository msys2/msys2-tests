cmake_minimum_required(VERSION 3.10)

project(Example VERSION 1.0)

add_executable(example example.cxx)

enable_testing()
add_test(NAME test COMMAND $<TARGET_FILE:example>)