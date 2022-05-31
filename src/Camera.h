#pragma once

#include <glm/glm.hpp>
#include <glm/ext/matrix_transform.hpp>
#include <glad/glad.h>

enum Camera_Movement {
	FORWARD,
	BACKWARD,
	UP,
	DOWN,
	LEFT, 
	RIGHT,
};

// Default Values
const float YAW = -90.0f;
const float PITCH = 0.0f;
const float SPEED = 2.5f;
const float ZOOM = 45.0f;
const float SENSITIVITY = 0.1f;
class Camera
{
public:
	Camera(glm::vec3 position = glm::vec3(0.0f), glm::vec3 up = glm::vec3(0.0, 1.0, 0.0), float yaw = YAW, float pitch = PITCH);

	// Input
	void CameraInput(Camera_Movement direction, float deltaTime);
	void ProcessMouseMovement(float xoffset, float yoffset, GLboolean constrainPitch = true);
	void ProcessMouseScroll(float yoffset);

	glm::mat4 GetViewMatrix() { return glm::lookAt(Position, Position + Front, Up); }

	// camera options
	float MovementSpeed;
	float MouseSensitivity;
	float Zoom;

	// camera attributes
	glm::vec3 Position;
	glm::vec3 Front;
	glm::vec3 Right;
	glm::vec3 Up;
	glm::vec3 WorldUp;

	// euler Angles
	float Yaw;
	float Pitch;
private:
	void updateCameraVectors();
};

