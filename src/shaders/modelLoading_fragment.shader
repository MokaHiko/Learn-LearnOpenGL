#version 330 core
// * All lighting calculations are done in world space
out vec4 FragColor;

#define NR_POINT_LIGHTS 4

struct Material{
	sampler2D texture_diffuse1;
	sampler2D texture_specular1;
	float shininess;
};
struct DirLight{
	vec3 direction;
	// light properties
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
};
struct PointLight {
	vec3 position;

	// light properties
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;

	// attentuation
	float constant;
	float linear;
	float quadratic;
};

// in variables will be interpolated from 3 world position vectors of the triangle
in vec3 Normal;
in vec3 FragPos; 
in vec2 TexCoords;

// Lighting Functions
vec3 GetDirLight(DirLight light, vec3 normal, vec3 viewDir);
vec3 GetPointLight(PointLight light, vec3 normal, vec3 fragPos, vec3 viewDir);

// Buffer Functions
float near = 0.1;
float far = 100.0f;
float linearDepth(float depth);

// Uniforms
uniform DirLight dirLight;
uniform PointLight pointLights[NR_POINT_LIGHTS];

uniform vec3 viewPos;
uniform Material material;

void main()
{
	// properties
	vec3 norm = normalize(Normal);
	vec3 viewDir = normalize(viewPos - FragPos);

	// Directional Light
	vec3 result = GetDirLight(dirLight, norm, viewDir);

	// Point Lights
	for (int i = 0; i < NR_POINT_LIGHTS; i++)
	{
		result += GetPointLight(pointLights[i], norm, FragPos, viewDir);
	}

	FragColor = vec4(result , 1.0);
}

vec3 GetDirLight(DirLight light, vec3 normal, vec3 viewDir)
{
	// diffuse shading
	vec3 lightDir = -light.direction; // by convention light.direction is light to frag so negate for calculations
	float diff = max(dot(normal, lightDir), 0.0f);

	// specular shading
	vec3 reflectDir = reflect(light.direction, normal);
	float spec = pow(max(dot(viewDir, reflectDir), 0.0f), material.shininess);

	// apply material light maps
	vec3 ambient = light.ambient * texture(material.texture_diffuse1, TexCoords).rgb;
	vec3 diffuse = light.diffuse * diff *  texture(material.texture_diffuse1, TexCoords).rgb;
	vec3 specular = light.specular * spec * texture(material.texture_specular1, TexCoords).rgb;

	return (ambient + diffuse + specular);
}
vec3 GetPointLight(PointLight light, vec3 normal, vec3 fragPos, vec3 viewDir)
{
	vec3 lightDir = normalize(light.position - fragPos);

	// diffuse shading
	float diff = max(dot(lightDir, normal), 0.0f);

	// specular shading
	vec3 reflectDir = reflect(-lightDir, normal);
	float spec = pow(max(dot(reflectDir, viewDir), 0.0f), material.shininess);

	// attenuation
	float distance = length(light.position - fragPos);
	float attenuation = 1.0f / (light.constant + light.linear * distance + light.quadratic * distance);

	// apply material light maps
	vec3 ambient= light.ambient * texture(material.texture_diffuse1, TexCoords).rgb;
	vec3 diffuse = light.diffuse * diff *  texture(material.texture_diffuse1, TexCoords).rgb;
	vec3 specular = light.specular *  spec * texture(material.texture_specular1, TexCoords).rgb;

	ambient *= attenuation;
	diffuse *= attenuation;
	specular *= attenuation;

	return (ambient + diffuse + specular);
}

float linearDepth(float depth)
{
	// Depth Buffers
	float ndc = depth * 2.0f - 1.0; // transform depth values to ndc
	float linearDepth = (2.0 * near * far) / (far + near - ndc * (far - near));
	return linearDepth;
}
