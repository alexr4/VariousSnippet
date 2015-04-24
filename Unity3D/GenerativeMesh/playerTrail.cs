using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class playerTrail : MonoBehaviour 
{
	private List<Vector3> locHistory;
	private List<float> angleHistory;
	private Vector3 location;
	public GameObject origin;
	public float trailResolution;
	public int trailLength;
	private bool addVertex;
	
	//Debug Line
	private LineRenderer lr;
	private int lineLength;

	void Start()
	{
		location = new Vector3(origin.transform.position.x, 0.01f, origin.transform.position.z);
		locHistory = new List<Vector3> ();
		angleHistory = new List<float> ();
		//locHistory.Add (location);
		//debug
		lineLength = 2;
		lr = GetComponent<LineRenderer> ();
		lr.SetVertexCount (lineLength);
		lr.SetWidth (.5f, .5f); //Start & End width
	}
	
	void Update()
	{
		float distanceBeetweenOP = Vector3.Distance(origin.transform.position, location);
		if (distanceBeetweenOP > trailResolution) {
			addVertex = true;
			Vector3 newLoc = new Vector3 (origin.transform.position.x, 0.5f, origin.transform.position.z);
			locHistory.Add (newLoc);
			angleHistory.Add (getAngleBetween (newLoc, location));
			location = newLoc;
			lineLength = locHistory.Count;
		} else {
			addVertex = false;
		}

		ShowDebugLine();
		limitTrail ();
	}

	private void ShowDebugLine()
	{
		lr.SetVertexCount (lineLength);
		for (int i=0; i<locHistory.Count; i++) 
		{
			Vector3 loc1 = locHistory[i];
			lr.SetPosition(i, loc1);
		}
		/*
		Vector3 l0 = getLocation();
		Vector3 l1 = getPreviousLocation();
		Debug.Log ("----------------");
		Debug.Log ("Vec l0 "+l0);
		Debug.Log ("Vec l1 "+l1);
		Debug.Log ("Vec methode "+getAngleBetween (l0, l1));
		*/
	}

	private void limitTrail()
	{
		if (locHistory.Count > trailLength) 
		{
			locHistory.RemoveAt(0);
		}
	}

	//Get
	public Vector3 getLocation()
	{
		return location;
	}

	public Vector3 getPreviousLocation()
	{
		return locHistory [locHistory.Count - 2];
	}

	public float getAngleAtLocation()
	{
		return angleHistory [angleHistory.Count - 1];
	}

	public float getAngleAtPreviousLocation()
	{
		return angleHistory [angleHistory.Count - 2];
	}

	public List<Vector3> getLocationHistory()
	{
		return locHistory;
	}

	public List<float> getAngleHistory()
	{
		return angleHistory;
	}

	public int getLocationHistorySize()
	{
		return locHistory.Count;
	}

	public int getAngleHistorySize()
	{
		return angleHistory.Count;
	}

	public int getTrailLength()
	{
		return trailLength;
	}

	public bool isVertexAdded()
	{
		return addVertex;
	}

	private float getAngleBetween(Vector3 l0, Vector3 l1)
	{
		Vector3 t = new Vector2 (l1.x, l1.z);
		Vector3 o = new Vector2 (l0.x, l0.z);
		float beta = Vector3.Angle(t, o);//from-to

		return beta;
	}
}
