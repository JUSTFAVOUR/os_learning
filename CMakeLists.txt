cmake_minimum_required(VERSION 3.24)
project(oscar_learning C)

set(CMAKE_C_STANDARD 11)

include_directories(learning_testing_xpan)

add_executable(oscar_learning
        learning_testing_xpan/addition.c
        learning_testing_xpan/addition.h learning_testing_xpan/TestAddition.c)
