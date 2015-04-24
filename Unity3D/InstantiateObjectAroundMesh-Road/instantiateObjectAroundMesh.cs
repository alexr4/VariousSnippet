using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class instantiateObjectAroundMesh : MonoBehaviour {

	/*NOTA BENE :
	 * Le mesh route semble avoir une inversion d'indice de triangle sur son premier Quads (duo de triangles)
	 * 
	 * */

	//Mesh data
	private Mesh mesh;
	private List<Vector3> meshRightVerticesList;
	private List<Vector3> meshLeftVerticesList;

	//lists
	private List<GameObject> gameObjectList;
	private List<Vector3> rightVerticesList;
	private List<Vector3> leftVerticesList;
	private List<float> rightAnglesList;
	private List<float> leftAnglesList;

	public GameObject objectToInstantiate;
	public float offset;

	// Use this for initialization
	void Start () {
		init();
		loadMeshData();
		computeRightVerticesList();
		computeLeftVerticesList();
		instantiateRightObject();
		instantiateLeftObject();

		cleanAllList();
	}

	// Update is called once per frame
	void Update () {
		showVerticesList(rightVerticesList, Color.cyan);
		showVerticesList(leftVerticesList, Color.green);

		showNormals();
	}

	private void init()
	{
		mesh = GetComponent<MeshFilter>().mesh;
		meshRightVerticesList = new List<Vector3>();
		meshLeftVerticesList = new List<Vector3>();
		rightVerticesList = new List<Vector3>();
		leftVerticesList = new List<Vector3>();
		rightAnglesList = new List<float>();
		leftAnglesList = new List<float>();
	}

	private void cleanAllList()
	{
		meshRightVerticesList.Clear();
		meshLeftVerticesList.Clear();
		//rightVerticesList.Clear();
		//leftVerticesList.Clear();
		rightAnglesList.Clear();
		leftAnglesList.Clear();
	}

	private void loadMeshData()
	{

		Vector3[] vertices = mesh.vertices;
		Vector3[] normals = mesh.normals;
		int[] triangleList = mesh.triangles;

		
		//fixe the mesh coordinate bug from maya
		Vector3 v0 = vertices[0];
		Vector3 v2 = vertices[2];
		Vector3 v3 = vertices[3];
		
		vertices[0] = v3;
		vertices[2] = v0;
		vertices[3] = v2;

		//vertices & vertices
		for(int v = 0; v < vertices.Length; v++)
		{
			Vector3 vertice = transform.position + vertices[v];
			Vector3 normal = normals[v];
			//GameObject clone = Instantiate(objectToInstantiate, vertice, Quaternion.identity) as GameObject;
			//find which vertice is at port or starboard
			if(v%2 == 0)
			{
				meshRightVerticesList.Add(vertices[v]);
			}
			else
			{
				meshLeftVerticesList.Add(vertices[v]);
			}
		}
	}



	private void computeRightVerticesList()
	{
		for(int i = 1; i < meshRightVerticesList.Count; i++)
		{
			if(i < meshRightVerticesList.Count-1)
			{
				for(float j = 0; j < 1; j+= offset)
				{
					Vector3 point = Vector3.Lerp(meshRightVerticesList[i-1], meshRightVerticesList[i], j);
				
					rightVerticesList.Add(point);
				}
			}
			else
			{
				for(float j = 0; j <= 1; j+= offset)
				{
					Vector3 point = Vector3.Lerp(meshRightVerticesList[i-1], meshRightVerticesList[i], j);
					
					rightVerticesList.Add(point);
				}
			}
		}
	}

	private void instantiateRightObject()
	{
		for(int i = 0; i < rightVerticesList.Count; i++)
		{
			Vector3 loc0 = transform.position + rightVerticesList[i];
			Vector3 loc1 = Vector3.zero;
			
			if(i < leftVerticesList.Count - 1)
			{
				loc1 = transform.position + rightVerticesList[i+1];
			}
			else{
				loc1 = transform.position + rightVerticesList[i-1];
			}
			
			GameObject clone = Instantiate(objectToInstantiate, loc0, Quaternion.FromToRotation(loc0, loc1)) as GameObject;
			
			clone.transform.LookAt(loc1);
			clone.transform.parent = transform;
		}
	}

	private void computeLeftVerticesList()
	{
		for(int i = 1; i < meshLeftVerticesList.Count; i++)
		{
			if(i < meshLeftVerticesList.Count-1)
			{
				for(float j = 0; j < 1; j+= offset)
				{
					Vector3 point = Vector3.Lerp(meshLeftVerticesList[i-1], meshLeftVerticesList[i], j);
					
					leftVerticesList.Add(point);
				}
			}
			else
			{
				for(float j = 0; j <= 1; j+= offset)
				{
					Vector3 point = Vector3.Lerp(meshLeftVerticesList[i-1], meshLeftVerticesList[i], j);
					
					leftVerticesList.Add(point);
				}
			}
		}
	}
	
	private void instantiateLeftObject()
	{
		for(int i = 0; i < leftVerticesList.Count; i++)
		{
			Vector3 loc0 = transform.position + leftVerticesList[i];
			Vector3 loc1 = Vector3.zero;

			if(i < leftVerticesList.Count - 1)
			{
				loc1 = transform.position + leftVerticesList[i+1];
			}
			else{
				loc1 = transform.position + leftVerticesList[i-1];
			}

			GameObject clone = Instantiate(objectToInstantiate, loc0, Quaternion.FromToRotation(loc0, loc1)) as GameObject;

			clone.transform.LookAt(loc1);
			clone.transform.parent = transform;
		}
	}


	//--
	//Maths Methods
	private float MathfMap(float value, float start1, float stop1, float start2, float stop2) 
	{
		return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1));
	}
	
	//--
	//Debug Methods
	private void showDebugVector(Vector3 v, Vector3 o, float mag, Color c)
	{	
		v.Normalize();
		v *= mag;
		v += o;

		Debug.DrawLine(o, v, c); 
	}

	private void showDebugLine(Vector3 v, Vector3 o, Color c)
	{	
		Debug.DrawLine( transform.position + o,  transform.position + v, c); 
	}

	private void showVerticesList(List<Vector3> vecList, Color c)
	{
		for(int i = 1; i<vecList.Count; i++)
		{
			showDebugLine(vecList[i-1], vecList[i], c);


		}
	}

	private void showNormals()
	{
		Vector3[] vertices = mesh.vertices;
		Vector3[] normals = mesh.normals;
		
		//vertices & vertices
		for(int v = 0; v < vertices.Length; v++)
		{
			Vector3 vertice =  transform.position+vertices[v];
			Vector3 normal =  normals[v];
			
			showDebugVector(normal, vertice, 1.5f, Color.magenta);
		}
	}
	
}
