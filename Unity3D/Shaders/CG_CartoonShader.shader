Shader "Custom/CG_CartoonShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Ramp("Ramp Shading", 2D) = "white"{}
		_Intensity("Intensité", Range(1, 10)) = 5
	}
	
	
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
			 
        
		CGPROGRAM
		#include "CustomLighting.cginc"
		#pragma surface surf CG_CartoonShader
		

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
	FallBack "VertexLit"
}
