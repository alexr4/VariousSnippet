//Script based on http://www.kamend.com/2014/05/rendering-a-point-cloud-inside-unity/
using UnityEngine;
using System.Collections;

public class wireframe : MonoBehaviour {
	private Mesh mesh;
	private Vector3 v0, v1, v2, v3, v4, v5, v6, v7;

	public bool isMoving;
	
	void Start()
	{
		mesh = GetComponent<MeshFilter> ().mesh;
		computeCube();

	}

	void Update()
	{
		if(!isMoving)
		{

		}
		else
		{
			computeCube();
		}

		debugMode();
	}
	
	private void DefineVertexColor()
	{
		Vector3[] verticesList = mesh.vertices;
		Color[] vertexColorList = new Color[verticesList.Length];
		int[] indecies = new int[verticesList.Length];
		Bounds bounds = mesh.bounds;
		
		for (int i=0; i<verticesList.Length; i++) 
		{
			Vector3 v = verticesList[i];
			float lowX = bounds.size.x*-1;
			float highX = bounds.size.x;
			float lowY = bounds.size.y*-1;
			float highY = bounds.size.y;
			float lowZ = bounds.size.z*-1;
			float highZ = bounds.size.z;
			
			float r = MathfMap(v.x, lowX, highX, 0.0f, 1.0f);
			float g = MathfMap(v.y, lowY, highY, 0.0f, 1.0f);
			float b = MathfMap(v.z, lowZ, highZ, 0.0f, 1.0f);
			
			vertexColorList[i] = new Color(r, g, b);
			indecies[i] = i;
			
		}
		mesh.colors = vertexColorList;
		mesh.SetIndices (indecies, MeshTopology.Lines, 0);
	}

	private void debugMode()
	{

		//face 0
		Debug.DrawLine(v0, v1, Color.cyan);
		Debug.DrawLine(v1, v4, Color.cyan);
		Debug.DrawLine(v4, v2, Color.cyan);	
		Debug.DrawLine(v2, v0, Color.cyan);

		//face 1
		Debug.DrawLine(v3, v5, Color.cyan);
		Debug.DrawLine(v5, v7, Color.cyan);
		Debug.DrawLine(v7, v6, Color.cyan);	
		Debug.DrawLine(v6, v3, Color.cyan);

		//final lines	
		Debug.DrawLine(v6, v2, Color.cyan);
		Debug.DrawLine(v3, v0, Color.cyan);
		Debug.DrawLine(v4, v7, Color.cyan);
		Debug.DrawLine(v1, v5, Color.cyan);
	}

	private void computeCube()
	{
		Vector3 bs = transform.localScale;
		bs = bs/2;
		Vector3 o = transform.position;
		
		//defineVector
		v0 = new Vector3(o.x-bs.x, o.y-bs.y, o.z-bs.z);
		v1 = new Vector3(o.x+bs.x, o.y-bs.y, o.z-bs.z);
		v2 = new Vector3(o.x-bs.x, o.y+bs.y, o.z-bs.z);
		v3 = new Vector3(o.x-bs.x, o.y-bs.y, o.z+bs.z);

		
		v4 = new Vector3(o.x+bs.x, o.y+bs.y, o.z-bs.z);
		v5 = new Vector3(o.x+bs.x, o.y-bs.y, o.z+bs.z);
		v6 = new Vector3(o.x-bs.x, o.y+bs.y, o.z+bs.z);

		v7 = new Vector3(o.x+bs.x, o.y+bs.y, o.z+bs.z);
	}

	private float MathfMap(float value, float start1, float stop1, float start2, float stop2) 
	{
		return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1));
	}
}

