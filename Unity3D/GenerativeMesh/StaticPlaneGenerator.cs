using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class StaticPlaneGenerator : MonoBehaviour 
{
	private MeshFilter mf;
	private Mesh mesh;

	//List (Vertices / Triangles / Normals / Uvs)
	private List<Vector3> vertList;
	private List<int> triIndexList;
	private List<Vector3> normList;
	private List<Vector2> uvList;

	//parametric variables
	public float res;

	void Start()
	{
		initLists ();
		initMesh ();

		computeMesh ();
		updateMesh ();
	}
	
	private void computeMesh()
	{
		/*
		 2------------3
		 * *          *
		 *   *   [2]  *
		 *     *      *
		 *       *    *
		 * [1]     *  *
		 *           **
		 0------------1
		 * */
		//Vertices
		vertList.Add (new Vector3 (0,0,0));
		vertList.Add (new Vector3 (res, 0, 0));
		vertList.Add (new Vector3 (0,0,res));
		vertList.Add (new Vector3 (res,0,res));

		//Triangles index 
		/* ClockWise way
		 * Triangle1 : i, i+2, i+1
		 * Triangle2 : i+2, i+3, i+1
		 * */
		triIndexList.Add (0);
		triIndexList.Add (2);
		triIndexList.Add (1);

		triIndexList.Add (2);
		triIndexList.Add (3);
		triIndexList.Add (1);

		//Normals
		normList.Add (-Vector3.forward);
		normList.Add (-Vector3.forward);
		normList.Add (-Vector3.forward);
		normList.Add (-Vector3.forward);

		//UVs
		uvList.Add (new Vector2 (0,0));
		uvList.Add (new Vector2 (1,0));
		uvList.Add (new Vector2 (0,1));
		uvList.Add (new Vector2 (1,1));
	}

	private void initLists()
	{
		vertList = new List<Vector3> ();
		triIndexList = new List<int> ();
		normList = new List<Vector3> ();
		uvList = new List<Vector2> ();
	}
	
	private void initMesh()
	{
		mf = GetComponent<MeshFilter> ();
		mesh = new Mesh ();
		mf.mesh = mesh;
	}

	private void updateMesh()
	{
		mesh.Clear ();
		mesh.vertices = vertList.ToArray ();
		mesh.triangles = triIndexList.ToArray ();
		mesh.normals = normList.ToArray ();
		mesh.uv = uvList.ToArray ();
	}
}
