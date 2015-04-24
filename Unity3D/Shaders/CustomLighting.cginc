#ifndef CUSTOM_LIGHTING_INCLUDED
#define CUSTOM_LIGHTING_INCLUDED

//Propertie
fixed _RimPower;
float _ShadowIntensity;
fixed _Intensity;
float4 _ShadowTint;
sampler2D _Ramp;

//declare custom lighting model
inline fixed4 LightingHalfLambertRim(SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
{
			#ifndef USING_DIRECTIONAL_LIGHT
			lightDir = normalize(lightDir);
			#endif
			//compute HalfVector
			fixed3 halfVector = normalize(lightDir + viewDir);
			
			//Diffuse lighting
			fixed NdotL = max(0.0, dot(s.Normal, lightDir));
			
			//mor dotProduct
			fixed EdotH = max(0.0, dot(viewDir, halfVector));
			fixed NdotH = max(0.0, dot(s.Normal, halfVector));
			fixed NdotE = max(0.0, dot(s.Normal, viewDir));
			
			//HalfLambert
			fixed halfLambert = pow((NdotL * 0.5 + 0.5), 2.0);
			
			//RimLight
			fixed rimLight = 1-NdotE;
			rimLight = pow(rimLight, _RimPower) * NdotH;
			
			//finalColor
			fixed4 finalColor;
			finalColor.rgb = (s.Albedo* _LightColor0.rgb + rimLight)*(halfLambert * atten * 2);
			finalColor.a = 0.0;
			
			return finalColor;
}

//Sharp Cartoon, Shader
//lightingShaderPass
inline fixed4 LightingCG_CartoonShaderSharper(SurfaceOutput s, float3 lightDir, float3 atten)
{
	#ifndef USING_DIRECTIONAL_LIGHT
	lightDir = normalize(lightDir);
	#endif
	half NdotL = dot(lightDir, s.Normal);
	float intensity = max(0.0, NdotL);
	float limit = _Intensity*0.1;
	float shadowIntensity = _ShadowIntensity*0.1;
			
	//computeFinalColor
	float4 finalColor;
			
	if(intensity >= limit)
    {
    	finalColor.rgb = s.Albedo;
    } 
    else
    {
    	finalColor.rgb = s.Albedo * (_ShadowTint.rgb*shadowIntensity);
    	//c.rgb = _ShadowTint.rgb * s.Albedo;//; //* (NdotL) newColor*
    }
	finalColor.a = s.Alpha;
			
	//return
	return finalColor;
}
		
//Cartoon Shader
inline fixed4 LightingCG_CartoonShader(SurfaceOutput s, float3 lightDir, float3 atten)
{
	#ifndef USING_DIRECTIONAL_LIGHT
	lightDir = normalize(lightDir);
	#endif
	half NdotL = dot(lightDir, s.Normal);
	half diff = NdotL * 0.5 + 0.5;
	float intensity = _Intensity*0.1;
	float3 ramp = tex2D(_Ramp, float2(diff, diff)).rgb*intensity;
			
	//computeFinalColor
	float4 finalColor;
	finalColor.rgb = s.Albedo*ramp;//*(_ShadowTint*shadowIntensity));//*shadowIntensity);
	finalColor.a = s.Alpha;
	//return
	return finalColor;
}

#endif