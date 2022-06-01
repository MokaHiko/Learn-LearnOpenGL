#version 330 core

// * All lighting calculations are done in world space
out vec4 FragColor;

struct Material{
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
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

uniform vec3 lightPos;
uniform vec3 viewPos;
uniform vec3 lightColor;

uniform Material material;
uniform Light light;
void main()
{
	// ambient 
	vec3 ambient =  lightColor * material.ambient;

	// diffuse
	vec3 norm = normalize(Normal);
	vec3 lightDir = normalize(lightPos - FragPos);
	float diff = max(dot(norm, lightDir), 0); 
	vec3 diffuse = lightColor * (diff * material.diffuse);

	// specular
	vec3 viewDir = normalize(viewPos - FragPos);
	vec3 reflectDir = reflect(-lightDir, norm); 
	float spec = pow(max(dot(viewDir, reflectDir), 0.0f),
						material.shininess);
	vec3 specular = lightColor * (spec * material.specular);

	// light properties
	ambient *= light.ambient;
	specular *= light.specular;
	diffuse *= light.diffuse;

	vec3 result = ambient + diffuse + specular;
	FragColor = vec4(result , 1.0);
}