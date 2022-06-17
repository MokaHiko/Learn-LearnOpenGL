#version 330 core

layout (points) in; // geometry coming from vertex shader
layout (triangle_strip, max_vertices = 5) out; // geometry to output to fragment

// send to fragment
out vec3 fColor;

// recieve from vertex shader array of vertex data
in VS_OUT{
    vec3 color;
} gs_in[]; 

void build_house(vec4 position)
{    
    fColor = gs_in[0].color; // each vertex recieves the color of the last output (fColor) to fragment
    gl_Position = position + vec4(-0.2, -0.2, 0.0, 0.0);    // 1:bottom-left
    EmitVertex();   
    gl_Position = position + vec4( 0.2, -0.2, 0.0, 0.0);    // 2:bottom-right
    EmitVertex();
    gl_Position = position + vec4(-0.2,  0.2, 0.0, 0.0);    // 3:top-left
    EmitVertex();
    gl_Position = position + vec4( 0.2,  0.2, 0.0, 0.0);    // 4:top-right
    EmitVertex();
    gl_Position = position + vec4( 0.0,  0.4, 0.0, 0.0);    // 5:top
    fColor = vec3(1.0, 1.0, 1.0);  // change color of last vertex
    EmitVertex();
    EndPrimitive();
}
void main()
{
    // gl_in is a built array containing vec4 gl_Position, float gl_PointSize, float gl_ClipDistance()[];
    build_house(gl_in[0].gl_Position);
}