Shader "Custom/PerlinShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SecondTex ("Second Texture", 2D) = "white" {}
		_PerlinTex ("Perlin (RGB)", 2D) = "white" {}
		_incDodge ("incDodge", Range (0.01, 3)) = 0.35	
		_limitRGB ("limit (RGB)", Range (0.01, 1)) = 1
		_alphaTex0 ("alpha texture 0", Range(0.01, 1)) = 1
		_alphaTex1 ("alpha texture 1", Range(0.01, 1)) = 0.75
	}
	SubShader {
		Tags {"Queue"="Transparent" "RenderType"="Transparent" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert alpha

		sampler2D _MainTex;
		sampler2D _SecondTex;
		sampler2D _PerlinTex;
		float _incDodge;
		float _limitRGB;
		float _alphaTex0;
		float _alphaTex1;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 tex0 = tex2D (_MainTex, IN.uv_MainTex);
			half4 tex1 = tex2D (_SecondTex, IN.uv_MainTex);	
			half4 perlinTex = tex2D (_PerlinTex, IN.uv_MainTex);
			float4 var = 1.0f;
			
			
			
			if(perlinTex.r >= _limitRGB && perlinTex.g >= _limitRGB && perlinTex.b >= _limitRGB)
			{
				o.Albedo = tex0.rgb / (var - (perlinTex.rgb / _incDodge));
				o.Alpha = _alphaTex0 + (tex0.a - perlinTex.rgb);
			}
			else
			{
				o.Albedo = tex1.rgb / (var /2 - (_incDodge * perlinTex.rgb));
				o.Alpha = _alphaTex1;//1 - (tex1.a - perlinTex.rgb/2);
			}
			
		}
		ENDCG
	} 
	FallBack "Diffuse"
}

//Dodge Algo : tex0.rgb / (var - (perlinTex.rgb/_incDodge));