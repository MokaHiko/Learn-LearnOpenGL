#version 330 core

// * All lighting calculations are done in world space
out vec4 FragColor;

struct Material{
	sampler2D diffuse;
	sampler2D specular;
	float shininess;
};

struct Light {
	vec3 position;

	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
};

// in variables will be interpolated from 3 world position vectors of the triangle
in vec3 Normal;
in vec3 FragPos; 
in vec2 TexCoords;

uniform vec3 viewPos;
uniform Material material;
uniform Light light;
void main()
{
	// ambient 
	vec3 ambient = vec3(texture(material.diffuse, TexCoords)); // using diffuse map

	// diffuse
	vec3 norm = normalize(Normal);
	vec3 lightDir = normalize(light.position - FragPos);
	float diff = max(dot(norm, lightDir), 0); 
	vec3 diffuse =  vec3(diff * texture(material.diffuse, TexCoords)); // diffuse map

	// specular
	vec3 viewDir = normalize(viewPos - FragPos);
	vec3 reflectDir = reflect(-lightDir, norm); 
	float spec = pow(max(dot(viewDir, reflectDir), 0.0f),
						material.shininess);
	vec3 specular = spec * vec3(texture(material.specular, TexCoords)); // specular map

	// light properties
	ambient *= light.ambient;
	specular *= light.specular;
	diffuse *= light.diffuse;

	vec3 result = ambient + diffuse + specular;
	FragColor = vec4(result , 1.0);
}