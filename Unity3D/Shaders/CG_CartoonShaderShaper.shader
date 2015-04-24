Shader "Custom/CG_CartoonShaderSharper" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Intensity("Intensité", Range(1, 10)) = 5
		_ShadowIntensity("Intensité de l'ombre", Range(0.0, 10)) = 1
		_ShadowTint("Shadow Tint", Color) = (1,1,1,1)
	}
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#include "CustomLighting.cginc"
		#pragma surface surf CG_CartoonShaderSharper

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};
		
		
		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}

