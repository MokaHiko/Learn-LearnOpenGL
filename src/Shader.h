#pragma once

#include <glad/glad.h>

#include <string>
#include <sstream>
#include <fstream>
#include <iostream>
#include <glm/glm.hpp>

class Shader
{
public:
	Shader(const char* vertexPath, const char* fragmentPath, const char* geometryPath = nullptr); 
	~Shader();

	void use();
	void unuse();

	void setBool(const std::string& name, bool val) const;
	void setInt(const std::string& name,  int val) const;
	void setFloat(const std::string& name, float val) const;
	void setMat4(const std::string& name, glm::mat4 val) const;
	void setVec3(const std::string& name, glm::vec3 val) const;
private:
	unsigned int ID;
	
	void compileShaders(const char* vCode, const char* fCode, const char* gCode = nullptr);
};

