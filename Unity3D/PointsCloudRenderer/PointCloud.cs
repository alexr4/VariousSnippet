//Script based on http://www.kamend.com/2014/05/rendering-a-point-cloud-inside-unity/
using UnityEngine;
using System.Collections;

public class PointCloud : MonoBehaviour {
	private Mesh mesh;

	void Start()
	{
		mesh = GetComponent<MeshFilter> ().mesh;

		DefineVertexColor();
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
		mesh.SetIndices (indecies, MeshTopology.Points, 0);
	}

	private float MathfMap(float value, float start1, float stop1, float start2, float stop2) 
	{
		return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1));
	}
}
