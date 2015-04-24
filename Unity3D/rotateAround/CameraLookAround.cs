using UnityEngine;
using System.Collections;

public class ObjectLookAround : MonoBehaviour {

	public Transform transformTarget;
	public Vector3 vecTarget;
	public bool isVecTarget;
	public bool isTransformTarget;
	public float speed;
	public Vector3 rotateAxis;


	// Use this for initialization
	void Start () {
		if(isTransformTarget)
		{
			transform.LookAt(transformTarget);
		}
		else if(isVecTarget)
		{
			transform.LookAt(vecTarget);
		}
	}
	
	// Update is called once per frame
	void Update () {
		if(isTransformTarget)
		{
			transform.RotateAround(transformTarget.position, rotateAxis, speed * Time.deltaTime);
		}
		else if(isVecTarget)
		{
			transform.RotateAround(vecTarget, rotateAxis, speed * Time.deltaTime);
		}
	}
}