cmake_minimum_required(VERSION 3.23.2)

project(LearnOpenGL_Part4)

add_executable(${PROJECT_NAME} 
    ./src/main.cpp
    ./src/Shader.cpp
    ./src/Camera.cpp
    )
add_subdirectory(./dependencies/MyMath)
add_subdirectory(./dependencies/glad)
add_subdirectory(./dependencies/glm)

target_include_directories(${PROJECT_NAME} 
    PRIVATE ./dependencies
    PRIVATE ./dependencies/GLFW/include
    PRIVATE ./dependencies/glad/include
    PRIVATE ./dependencies/glm
    )
target_link_directories(${PROJECT_NAME} 
    PRIVATE ./dependencies/GLFW/lib)
target_link_libraries(${PROJECT_NAME} 
    PRIVATE glad
    PRIVATE MyMath
    PRIVATE glm
    PRIVATE glfw3.lib
    PRIVATE opengl32.lib
    )

add_custom_target(
    copy_resources ALL
    COMMAND ${CMAKE_COMMAND} -E copy_directory 
    ${PROJECT_SOURCE_DIR}/resources
    ${PROJECT_BINARY_DIR}/resources
    COMMENT "Copying Resources Into binary folder"
    )

add_dependencies(${PROJECT_NAME} copy_resources)

#add_compile_definitions(_APPLE_)