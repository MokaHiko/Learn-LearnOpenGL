#version 330 core

out vec4 FragColor;
//in vec2 TexCoord;

//uniform sampler2D texture1;
//vec3 Color = vec3(1.0f);
// uniform sampler2D texture2;

void main()
{
	//FragColor = texture(texture1, TexCoord) * vec4(Color, 1.0);
	FragColor = vec4(1.0, 0.0, 0.0, 1.0);
}