using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class flock : MonoBehaviour {

	public GameObject boidPrefab;
	public int swarmCount = 100;

	private List<GameObject> boidList;

	// Use this for initialization
	void Awake()
	{
		boidList = new List<GameObject>();
		for (int i = 0; i < swarmCount; i++)
		{
			GameObject clone = Instantiate(boidPrefab, Random.insideUnitSphere * 25, Quaternion.identity) as GameObject;
			boidList.Add(clone);
		}
	}

	void Start () {
		for (int i=0; i < boidList.Count; i++)
		{
			boid ba = boidList[i].GetComponent<boid>();
			ba.setId(i);

		}
	
	}

	void Update()
	{
		/*
		foreach(GameObject boid in boidList)
		{
			boid ba = boid.GetComponent<boid>();
			if(!ba.isArrived())
			{
				ba.arriveAt(new Vector3(20, 20, 20));
			}
			//Debug.Log("boid "+ba.getId()+" seek "+ba.getFlockingOrigin());
		}
		*/
	}
}