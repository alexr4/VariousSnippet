//blendMode Algorythme create by Robert Menzel (@renderpipeline) 
//Link : http://renderingpipeline.com/2012/06/photoshop-blendmodi-glsl/

uniform sampler2D tex; //sampler2D is texture in GPU
uniform sampler2D mask; //sampler2D is texture in GPU
uniform int choice;

void main()
{
	vec4 texColor = texture2D(tex, gl_TexCoord[0].xy);
	vec4 texMask = texture2D(mask, gl_TexCoord[0].xy);
	vec4 blendMode = vec4(1.0) - ((vec4(1.0) - texMask) * (vec4(1.0) - texColor));
	
	gl_FragColor = blendMode;
}