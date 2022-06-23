#version 330 core

struct Material{
	sampler2D texture_diffuse1;
	sampler2D texture_specular1;
	float shininess; 
};

out vec4 FragColor; 

in VS_OUT{
	vec2 texCoords;
}fs_in;


uniform Material material;

void main()
{
    FragColor = texture(material.texture_diffuse1, fs_in.texCoords);
}