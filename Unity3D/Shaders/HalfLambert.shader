Shader "Custom/HalfLambertRim" {
	Properties {
		_MainTint("Main tint", Color) = (0.5, 0.5, 0.5, 0.5)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_RimPower("Rim power", Range(0.01, 3.0)) = 1.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#include "CustomLighting.cginc"
		#pragma surface surf HalfLambertRim
		

		sampler2D _MainTex;
		fixed4 _MainTint;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb*_MainTint;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
