#version 330 core

out vec4 FragColor;

in vec3 fColor;

void main()
{
    FragColor = vec4(fColor.rgb, 1.0);
}