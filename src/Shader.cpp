#include "Shader.h"
#include <glm/gtc/type_ptr.hpp>

Shader::Shader(const char* vertexPath, const char* fragmentPath, const char* geometryPath) 
	:ID(NULL)
{
	std::string vertexCode;
	std::string fragmentCode;
	std::string geometryCode;
	std::ifstream vShaderFile;
	std::ifstream fShaderFile;
	std::ifstream gShaderFile;
	
	// ifstream exceptios
	vShaderFile.exceptions(std::ifstream::failbit | std::ifstream::badbit);
	fShaderFile.exceptions(std::ifstream::failbit | std::ifstream::badbit);
	if(geometryPath)
		gShaderFile.exceptions(std::ifstream::failbit | std::ifstream::badbit);

	try
	{
		vShaderFile.open(vertexPath);
		fShaderFile.open(fragmentPath);

		// read buffer content into stream
		std::stringstream vShaderStream, fShaderStream;
		vShaderStream << vShaderFile.rdbuf();
		fShaderStream << fShaderFile.rdbuf();

		vShaderFile.close();
		fShaderFile.close();

		// convert from stream into string
		vertexCode = vShaderStream.str();
		fragmentCode = fShaderStream.str();

		if(geometryPath)
		{
			gShaderFile.open(geometryPath);
			std::stringstream gShaderStream;
			gShaderStream << gShaderFile.rdbuf();

			gShaderFile.close();

			geometryCode = gShaderStream.str(); 
		}
	}
	catch (std::ifstream::failure e)
	{
		std::cout << "ERROR::SHADER::FAILED_NOT_SUCCESFULLY_READ" << std::endl;
	}

	// compile shaders
	if(geometryPath)
		compileShaders(vertexCode.c_str(), fragmentCode.c_str(), geometryCode.c_str());
	else
		compileShaders(vertexCode.c_str(), fragmentCode.c_str());
}

Shader::~Shader()
{
	glDeleteProgram(ID);
}

void Shader::use()
{
	glUseProgram(ID);
}

void Shader::unuse()
{
	glUseProgram(0);
}

void Shader::setBool(const std::string& name, bool value) const
{
	glUniform1i(glGetUniformLocation(ID, name.c_str()), (int)value);
}
void Shader::setInt(const std::string& name, int value) const
{
	glUniform1i(glGetUniformLocation(ID, name.c_str()), value);
}
void Shader::setFloat(const std::string& name, float value) const
{
	glUniform1f(glGetUniformLocation(ID, name.c_str()), value);
}

void Shader::setMat4(const std::string& name, glm::mat4 val) const
{
	glUniformMatrix4fv(glGetUniformLocation(ID, name.c_str()), 1, GL_FALSE, glm::value_ptr(val));
}

void Shader::setVec3(const std::string& name, glm::vec3 val) const
{
	glUniform3fv(glGetUniformLocation(ID, name.c_str()), 1, glm::value_ptr(val));
}

void Shader::setVec2(const std::string& name, glm::vec2 val) const
{
	glUniform2fv(glGetUniformLocation(ID, name.c_str()), 1, glm::value_ptr(val));
}

void Shader::compileShaders(const char* vCode, const char* fCode, const char* gCode)
{
	// params
	int success;
	char infoLog[512];

	unsigned int vShader = glCreateShader(GL_VERTEX_SHADER);
	glShaderSource(vShader, 1, &vCode, nullptr);
	glCompileShader(vShader);

	glGetShaderiv(vShader, GL_COMPILE_STATUS, &success);
	if (!success)
	{
		glGetShaderInfoLog(vShader, 512, nullptr, infoLog);
		std::cout << "ERROR::SHADER::VERTEX_SHADER::FAILED_TO_COMPILE: "  << infoLog << std::endl;
	}

	unsigned int fShader = glCreateShader(GL_FRAGMENT_SHADER);
	glShaderSource(fShader, 1, &fCode, nullptr);
	glCompileShader(fShader);

	glGetShaderiv(fShader, GL_COMPILE_STATUS, &success);
	if (!success)
	{
		glGetShaderInfoLog(fShader, 512, nullptr, infoLog);
		std::cout << "ERROR::SHADER::FRAGMENT_SHADER::FAILED_TO_COMPILE: " << infoLog << std::endl;
	}

	unsigned int gShader;
	if(gCode)
	{
		gShader = glCreateShader(GL_GEOMETRY_SHADER);
		glShaderSource(gShader, 1, &gCode, nullptr);
		glCompileShader(gShader);

		glGetShaderiv(gShader, GL_COMPILE_STATUS, &success);
		if(!success)
		{
			glGetShaderInfoLog(gShader, 512, nullptr, infoLog);
			std::cout << "ERROR:SHADER::GEOMETRY_SHADER::FAILED_TO_COMPILE: " << infoLog << std::endl;
		}
	}

	// create shader program
	ID = glCreateProgram();
	glAttachShader(ID, vShader);
	glAttachShader(ID, fShader);
	if(gCode)
		glAttachShader(ID, gShader);
	glLinkProgram(ID);

	glGetProgramiv(ID, GL_LINK_STATUS, &success);
	if (!success)
	{
		glGetProgramInfoLog(ID, 512, nullptr, infoLog);
		std::cout << "ERROR::SHADER::PROGRAM::FAILED_TO_LINK: " << infoLog <<  std::endl;
	}

	glDeleteShader(vShader);
	glDeleteShader(fShader);
	if(gCode)
		glDeleteShader(gShader);
}
