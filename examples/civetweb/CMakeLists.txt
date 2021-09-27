cmake_minimum_required(VERSION 3.12 FATAL_ERROR)
project(civet-server)

add_executable(emb-civet-server embedded_cpp.cpp)
target_link_libraries(emb-civet-server
        PUBLIC civetserver
        PUBLIC civetweb)

