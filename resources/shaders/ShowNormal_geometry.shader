
#version 330 core
layout (triangles) in;
layout (line_strip, max_vertices = 6) out;

const float magnitude = 0.4f;

uniform mat4 projection;

out vec2 TexCoords;

in VS_OUT{
    vec3 normal;
}gs_in[];

void GenerateLine(int idx)
{
    gl_Position = projection * gl_in[idx].gl_Position;
    EmitVertex();
    gl_Position = projection * (gl_in[idx].gl_Position + vec4(gs_in[idx].normal * magnitude, 0.0));
    EmitVertex();
    EndPrimitive();
}

void main()
{
    GenerateLine(0);
    GenerateLine(1);
    GenerateLine(2);
}