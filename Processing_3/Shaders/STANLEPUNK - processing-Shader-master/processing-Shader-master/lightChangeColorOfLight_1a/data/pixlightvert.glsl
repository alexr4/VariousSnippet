#define PROCESSING_LIGHT_SHADER

uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

uniform vec4 lightPosition;
uniform vec3 lightNormal;
uniform vec3 colorLight;

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 lightDir;


void main() {
  gl_Position = transform * vertex;    
  vec3 ecVertex = vec3(modelview * vertex);  

  // here, we divide by 255 because it's a max of the color data in the RGB world
  vec3 normColorLight = vec3(colorLight/255.) ;
  
  ecNormal = normalize(normalMatrix *normal);
  lightDir = normalize(lightPosition.xyz - ecVertex);  

  vec4 newColor = vec4(color.r *normColorLight.r, color.g *normColorLight.g, color.b *normColorLight.b, color.a) ;
  vertColor = newColor ;
}