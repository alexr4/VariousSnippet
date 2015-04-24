using UnityEngine;

public class screenshot : MonoBehaviour
{
	private int count;
	
	void Update()
	{
		if (Input.GetButtonDown("Jump"))
		{
			Capture();
		}
	}
	
	void Capture()
	{
		Application.CaptureScreenshot(Application.dataPath + "/Screenshot_" + count + ".png");
		count++;
	}
}