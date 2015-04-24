uniform samplerCube cubemap;

varying vec3 reflectDir;
varying vec3 refractDir;
varying float refractRatio;

void main() {
	vec4 mainColor = vec4(0, 0, 0, 0.25);

  	vec3 refle = vec3(reflectDir.x, -reflectDir.y, reflectDir.z);
  	vec3 refra = vec3(refractDir.x, -refractDir.y, refractDir.z);

  	vec4 refractColor = textureCube(cubemap, refra);
  	refractColor = mix(refractColor, mainColor, 0.25);

  	vec4 reflectColor = textureCube(cubemap, refle);
  	reflectColor = mix(reflectColor, mainColor, 0.0);

  	gl_FragColor = reflectColor;//refractColor;//mix(reflectColor, refractColor, refractRatio);//;//


}
