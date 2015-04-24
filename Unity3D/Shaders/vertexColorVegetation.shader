Shader "Custom/vertexColorVegetation" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 vertColors;
		};
		
		void vert(inout appdata_full v, out Input o)
		{
			o.vertColors = v.color.rgb;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			float3 c2 = float3(c.r+(IN.vertColors.r*0.25), (c.g+IN.vertColors.g)*0.6, (c.b*IN.vertColors.b)*0.6);
			o.Albedo = c.rgb+(IN.vertColors.rgb*0.15);
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
