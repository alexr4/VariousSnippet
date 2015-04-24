Shader "Custom/backfaceCulling" {
	Properties {
	}
	SubShader {
        Pass {
            Material {
                Diffuse (1,1,1,1)
            }
            Lighting On
            Cull Off
        }
        
    }
	FallBack "Diffuse"
}
