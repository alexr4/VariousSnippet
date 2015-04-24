size(100, 100, P3D);
PGraphicsOpenGL pg = (PGraphicsOpenGL)g;
String GPU_Vendor = pg.OPENGL_VENDOR;
String GPU_OpenGL_Renderer = pg.OPENGL_RENDERER;
String GPU_OpenGL_Version = pg.OPENGL_VERSION;
String GPU_GLSL_Version = pg.GLSL_VERSION;
String GPU_GlobalOpenGL_Extensions = pg.OPENGL_EXTENSIONS;
String GPU_OpenGl_Extensions = "OpenGL Extension : \n";

int index = 0;
for(int i=0; i<GPU_GlobalOpenGL_Extensions.length(); i++)
{
  char c = GPU_GlobalOpenGL_Extensions.charAt(i);
  if(c == ' ')
  {
    GPU_OpenGl_Extensions += "\t"+GPU_GlobalOpenGL_Extensions.substring(index, i)+"\n";
    index = i;
  }
}

println("GPU Vendor : "+GPU_Vendor);
println("GPU OpenGL Renderer : "+GPU_OpenGL_Renderer);
println("GPU OpenGL Version : "+GPU_OpenGL_Version);
println("GPU GLSL Version : "+GPU_GLSL_Version);
println(GPU_OpenGl_Extensions);
println("MAX texture size : "+pg.maxTextureSize);
