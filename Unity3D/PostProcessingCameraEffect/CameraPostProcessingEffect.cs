using UnityEngine;
using System.Collections;

public class CameraPostProcessingEffect : MonoBehaviour {

	public Material geyscaleMate;

	// Called by the camera to apply the image effect
	void OnRenderImage (RenderTexture source, RenderTexture destination){	
		//geyscaleMate is the material containing your shader
		Graphics.Blit(source,destination,geyscaleMate);
	}
}
