void main()
{
	//transform the shader from local space to perspective space
	//gl_position = output (ReadOnly)
	//gl_vertex = input (local position)
	//gl_ModelViewProjectionMatrix = input (given by openGL)
	gl_Position = gl_ModelViewProjectionMatrix*gl_Vertex;

	//gl_MultiTexCoord0 is input symbol (read)
	//gl_TexCoord[0] is output (write)
	gl_TexCoord[0] = gl_MultiTexCoord0;
}