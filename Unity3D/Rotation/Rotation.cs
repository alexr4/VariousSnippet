using UnityEngine;
using System.Collections;

public class Rotation : MonoBehaviour {

	public float angularSpeedX;
	public float angularSpeedY;

	// Use this for initialization
	void Start () {
		
		rigidbody.AddTorque(transform.up * angularSpeedY, ForceMode.Force);
		rigidbody.AddTorque(transform.right * angularSpeedX, ForceMode.Force);
	}
	
	// Update is called once per frame
	void Update () {
	}
}ransform.RotateAround (point,new Vector3(0.0f,1.0f,0.0f),20 * Time.deltaTime * speedMod);
}