#version 330 core

layout (location = 0) in vec3 aPos;
layout (location = 1) in vec2 TexCoords;
layout (location = 3) in mat4 instanceMatrix;

uniform mat4 projection;
uniform mat4 view;

out VS_OUT
{
	vec2 texCoords;
}vs_out;

void main()
{
	vs_out.texCoords = TexCoords;
	gl_Position = projection * view * instanceMatrix * vec4(aPos, 1.0f);
}