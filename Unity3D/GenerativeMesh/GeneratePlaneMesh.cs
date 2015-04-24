using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GeneratePlaneMesh : MonoBehaviour {

	//Init Variables
	public float width = 1.0f;
	public float height = 1.0f;
	public float depth = 1.0f;
	private List<Vector3> vertexList = new List<Vector3>();
	private List<int> triIndexList = new List<int>();
	private List<Vector3> normalsList = new List<Vector3>();
	private List<Vector2> uvList = new List<Vector2>();
	private MeshFilter mf;
	private Mesh mesh;

	//List from Trail 
	private playerTrail trailInformation;
	public float radius;
	public float vertPosition;

	void Start () {
		loadInformationFromTrail ();
		InitMesh ();
	}

	void Update()
	{
		if (trailInformation.getLocationHistorySize() > 2) 
		{
			//Debug.Log("need to Compute Mesh");
			computeMeshInformation ();
			computeMesh ();
			//limiteMeshGeneration();
		}

		//debugVertList ();
	}

	private void InitMesh()
	{
		mf = GetComponent<MeshFilter> ();
		mesh = new Mesh ();
		mf.mesh = mesh;
	}
	
	private void loadInformationFromTrail()
	{
		GameObject gameControllerObject = GameObject.FindWithTag ("trail");
		if (gameControllerObject != null)
		{
			trailInformation = gameControllerObject.GetComponent <playerTrail>();
		}
		if (trailInformation == null)
		{
			Debug.Log ("Cannot find 'GameController' script");
		}
	}

	private void computeMeshInformation()
	{
		if (trailInformation.isVertexAdded ()) 
		{
			//Spine position
			Vector3 o0 = trailInformation.getPreviousLocation();
			Vector3 o1 = trailInformation.getLocation();
			float a0 = trailInformation.getAngleAtPreviousLocation();
			float a1 = trailInformation.getAngleAtLocation();

			//compute new Mesh Vertex
			Vector3 l0 = new Vector3 ();
			Vector3 l1 = new Vector3 ();
			Vector3 l2 = new Vector3 ();
			Vector3 l3 = new Vector3 ();

			l0.x = o0.x + Mathf.Cos (a0 - Mathf.PI / 2) * radius;
			l0.y = vertPosition;
			l0.z = o0.z + Mathf.Sin (a0 - Mathf.PI / 2) * radius;

			l1.x = o0.x + Mathf.Cos (a0 + Mathf.PI / 2) * radius;
			l1.y = vertPosition;
			l1.z = o0.z + Mathf.Sin (a0 + Mathf.PI / 2) * radius;
		
			l2.x = o1.x + Mathf.Cos (a1 - Mathf.PI / 2) * radius;
			l2.y = vertPosition;
			l2.z = o1.z + Mathf.Sin (a1 - Mathf.PI / 2) * radius;
		
			l3.x = o1.x + Mathf.Cos (a1 + Mathf.PI / 2) * radius;
			l3.y = vertPosition;
			l3.z = o1.z + Mathf.Sin (a1 + Mathf.PI / 2) * radius;

			//Add to vertexList
			vertexList.Add (l0);
			vertexList.Add (l1);
			vertexList.Add (l2);
			vertexList.Add (l3);

			//Triangle Information
			triIndexList.Add (0); 
			triIndexList.Add (1);
			triIndexList.Add (2);

			triIndexList.Add (2);
			triIndexList.Add (3);
			triIndexList.Add (1);

			//Normals
			normalsList.Add (-Vector3.forward);
			normalsList.Add (-Vector3.forward);
			normalsList.Add (-Vector3.forward);
			normalsList.Add (-Vector3.forward);
			
			//UVs
			uvList.Add (new Vector2 (0, 0));
			uvList.Add (new Vector2 (1, 0));
			uvList.Add (new Vector2 (0, 1));
			uvList.Add (new Vector2 (1, 1));
			
		}
	}

	private void limiteMeshGeneration()
	{
		if (trailInformation.getLocationHistorySize() >= trailInformation.getTrailLength ()) 
		{
			Debug.Log (vertexList.Count);

			vertexList.RemoveAt(0);
			vertexList.RemoveAt(1);
			vertexList.RemoveAt(2);
			vertexList.RemoveAt(3);

			
			triIndexList.RemoveAt(0);
			triIndexList.RemoveAt(1);
			triIndexList.RemoveAt(2);
			triIndexList.RemoveAt(3);
			triIndexList.RemoveAt(4);
			triIndexList.RemoveAt(5);

			normalsList.RemoveAt(0);
			normalsList.RemoveAt(1);
			normalsList.RemoveAt(2);
			normalsList.RemoveAt(3);
			
			uvList.RemoveAt(0);
			uvList.RemoveAt(1);
			uvList.RemoveAt(2);
			uvList.RemoveAt(3);
		}
	}

	private void computeMesh()
	{
		//Debug.Log("\tCompute Mesh");
		//assignArray
		mesh.Clear();
		mesh.vertices = vertexList.ToArray();
		mesh.triangles = triIndexList.ToArray();
		//mesh.normals = normalsList.ToArray();
		mesh.uv = uvList.ToArray();
		mesh.RecalculateNormals ();
	}

	private void debugVertList()
	{
		Debug.Log("-------------------");
		foreach(Vector3 v in vertexList)
		{
			Debug.Log(v);
		}
	}

}
