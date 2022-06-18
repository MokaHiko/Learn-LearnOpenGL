#version 330 core

layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal; 
layout (location = 2) in vec2 aTexCoords;

out VS_OUT
{
    vec3 normal;
    vec2 texCoords;
}vs_out;

uniform mat4 model;
uniform mat4 view;

void main()
{
    mat3 normalMatrix = transpose(inverse(view * model)); // in view space
    vs_out.normal = normalize(vec3(vec4(aNormal * normalMatrix, 0)));
    vs_out.texCoords = aTexCoords;
    
    gl_Position = view * model * vec4(aPos, 1.0f);
}