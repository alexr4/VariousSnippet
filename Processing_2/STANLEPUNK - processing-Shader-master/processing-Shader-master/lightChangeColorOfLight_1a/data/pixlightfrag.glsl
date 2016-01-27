#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 lightDir;



void main() {  
  vec3 direction = normalize(lightDir);
  vec3 normal = normalize(ecNormal);
  float intensity = max(0.0, dot(direction, normal));

  // vec3 finalColorLight = normalize(colorLight) ;


  // vec4 color = vec4(vertColor.x *finalColorLight.x, vertColor.y *finalColorLight.y, vertColor.z *finalColorLight.z, vertColor.w *1.);
  //gl_FragColor = vec4(intensity, intensity, intensity, 1) *color;

  // vec4 color = vec4(intensity *colorLight.x, intensity *colorLight.y, intensity *colorLight.z, 1.);
  // gl_FragColor = color *vertColor;
  
  // original
  gl_FragColor = vec4(intensity, intensity, intensity, 1) *vertColor;
}