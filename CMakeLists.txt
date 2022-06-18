cmake_minimum_required(VERSION 3.23.2)

project(LearnOpenGL_Part4)

add_executable(${PROJECT_NAME} 
    ./src/main.cpp
    ./src/Shader.cpp
    ./src/Camera.cpp
    ./src/Mesh.cpp
    ./src/Model.cpp
    )
add_subdirectory(./dependencies/MyMath)
add_subdirectory(./dependencies/glad)
add_subdirectory(./dependencies/glm)

target_include_directories(${PROJECT_NAME} 
    PRIVATE ./dependencies
    PRIVATE ./dependencies/GLFW/include
    PRIVATE ./dependencies/glad/include
    PRIVATE ./dependencies/assimp/include
    PRIVATE ./dependencies/glm
    )

target_link_directories(${PROJECT_NAME} 
    PRIVATE ./dependencies/GLFW/lib
    PRIVATE ./dependencies/assimp/lib)

target_link_libraries(${PROJECT_NAME}
    PRIVATE MyMath
    PRIVATE glad
    PRIVATE glm
    PRIVATE glfw3
    PRIVATE opengl32
    PRIVATE assimp-vc143-mtd
    )

# move dlls
add_custom_command(
    TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${PROJECT_SOURCE_DIR}/dependencies/assimp/lib/assimp-vc143-mtd.dll"
    ${PROJECT_BINARY_DIR}
    COMMENT "Copying dll to binary folder"
)

# copy resources
add_custom_target(
    copy_resources ALL
    COMMAND ${CMAKE_COMMAND} -E copy_directory 
    ${PROJECT_SOURCE_DIR}/resources
    ${PROJECT_BINARY_DIR}/resources
    COMMENT "Copying Resources Into binary folder"
    )

add_dependencies(${PROJECT_NAME} copy_resources)

add_compile_definitions(_APPLE_)