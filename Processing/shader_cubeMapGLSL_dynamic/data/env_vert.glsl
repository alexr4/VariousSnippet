uniform mat4 transform;uniform mat4 modelview;uniform mat3 normalMatrix;uniform mat4 camMatrix;attribute vec4 vertex;attribute vec3 normal;varying vec3 reflectDir;varying vec3 refractDir;varying float refractRatio;uniform float fresnel; // Ratio of indices of refractionconst float fresnelPower = 0.5;void main() {	//camera information  vec3 eyeNormal =  normalize(normalMatrix * normal);   vec4 vertexPos =  normalize(modelview * vertex);   //Reflection  reflectDir =  reflect(vertexPos.xyz, eyeNormal);  vec4 reflectMatrixCorrection = camMatrix * vec4(reflectDir, 0);  reflectDir = reflectMatrixCorrection.xyz;  //Refracction  refractDir =  refract(vertexPos.xyz, eyeNormal, fresnel);  vec4 refractMatrixCorrection = camMatrix * vec4(refractDir, fresnel);  refractDir = refractMatrixCorrection.xyz;  float f = ((1.0-fresnel) * (1.0-fresnel)) / ((1.0+fresnel) * (1.0+fresnel));  refractRatio = f + (1.0 - f) * pow((1.0 - dot(-normalize(vertexPos.xyz), normalize(eyeNormal))), fresnelPower);  gl_Position = transform * vertex;}