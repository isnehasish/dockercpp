cmake_minimum_required(VERSION 3.12 FATAL_ERROR)

project(prom-civet)

set(CMAKE_CXX_STANDARD 11)

find_package(prometheus-cpp CONFIG REQUIRED)

add_executable(combined combined.cc)
target_link_libraries(combined
        PRIVATE prometheus-cpp::pull
        PUBLIC civetserver
        PUBLIC civetweb)

