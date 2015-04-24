using UnityEngine;
using System.Collections;

public class DirectorCamera : MonoBehaviour {
	public bool isVecTarget;
	public bool isTransformTarget;

	public bool isRotationMovement;
	public Transform transformTargetTorque;
	public Vector3 vecTargetTorque;
	private Vector3 torqueTarguet;
	public float speedTorque;
	public Vector3 rotateAxis;

	public bool isTravelingMovement;
	public bool isSeekingMovingObject;
	public Transform transformTarget;
	public Vector3 vecTarget;
	private Vector3 travelingTarget;
	private Vector3 finalTargetLoc;
	public bool axisX;
	public bool axisY;
	public bool axisZ;
	public float speed;

	
	
	// Use this for initialization
	void Start () {
		if(isRotationMovement)
		{
			if(isTransformTarget)
			{
				torqueTarguet = transformTargetTorque.position;
			}
			else if(isVecTarget)
			{
				torqueTarguet = vecTargetTorque;
			}

			transform.LookAt(torqueTarguet);
		}

		if(isTravelingMovement)
		{
			if(isTransformTarget)
			{
				travelingTarget = transformTarget.position;
			}
			else if(isVecTarget)
			{
				travelingTarget = vecTarget;
			}

			finalTargetLoc = transform.position;

			if(axisX)
			{
				finalTargetLoc.x = travelingTarget.x;
			}

			
			if(axisY)
			{
				finalTargetLoc.y = travelingTarget.y;
			}

			
			if(axisZ)
			{
				finalTargetLoc.z = travelingTarget.z;
			}
		}
	}
	
	// Update is called once per frame
	void Update () {
		rotateCam();
		travelingCam();
	}

	private void rotateCam()
	{
		if(isRotationMovement)
		{
			transform.RotateAround(torqueTarguet, rotateAxis, speedTorque * Time.deltaTime);
		}
	}

	private void travelingCam()
	{
		if(isTravelingMovement && !isSeekingMovingObject)
		{
			transform.position = Vector3.Lerp(transform.position, finalTargetLoc, speed*0.5f);
		}
		else if(isTravelingMovement && isSeekingMovingObject)
		{
			defineNewTargetPostion();
			transform.position = Vector3.Lerp(transform.position, finalTargetLoc, speed*0.5f);
		}
	}

	private void defineNewTargetPostion()
	{
		finalTargetLoc = transform.position;
		travelingTarget = transformTarget.parent.position;//+ transformTarget.position;
		
		if(axisX)
		{
			finalTargetLoc.x = travelingTarget.x;
		}
		
		
		if(axisY)
		{
			finalTargetLoc.y = travelingTarget.y;
		}
		
		
		if(axisZ)
		{
			finalTargetLoc.z = travelingTarget.z;
		}

		
		//transform.LookAt(finalTargetLoc);
	}
}
