#pragma once
#include <string>
#include <vector>

#include <glm/glm.hpp>

#include "Shader.h"
struct Vertex {
	glm::vec3 Position;
	glm::vec3 Normal;
	glm::vec2 TexCoords;
};

struct Texture {
	unsigned int id;
	std::string type; // i.e diffuse, specular, etc..
	std::string path; // path of texture
};

class Mesh
{
public:
	std::vector<Vertex> Vertices;
	std::vector<unsigned int> Indices;
	std::vector<Texture> Textures;

	Mesh(std::vector<Vertex> vertices, std::vector<unsigned int> indices, std::vector<Texture> textures);
	~Mesh();
	void Draw(Shader& shader);
private:
	void setUpMesh();

	// render data
	unsigned int VAO, VBO, EBO;
};

