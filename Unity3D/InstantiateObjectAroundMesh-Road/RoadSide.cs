using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class RoadSide : MonoBehaviour {
	
	/* Based on InstantiateObjectAroundMesh.cs
	 *
	 * NOTA BENE :
	 * Le mesh route semble avoir une inversion d'indice de triangle sur son premier Quads (duo de triangles)
	 * 
	 * Bonjour, interactive lab
	 * August 2014
	 * */

	//Private variables
	//Raw Mesh data
	private Mesh mesh;
	private List<Vector3> meshRightVerticesList;
	private List<Vector3> meshLeftVerticesList;
	private List<Vector2> meshRightDirectionsAndAngles;
	private List<Vector2> meshLeftDirectionsAndAngles;

	//Public variables
	public int facesPerBendAnalysis;
	public bool analyzeLeftSide;
	public bool analyzeRightSide;
	public float tightBendAt;
	public float bendAt;

	//debug
	public GameObject objectToInstantiate;

	//--
	//Start & Update
	void Start () {
		init();
		loadMeshData();
		fillDirectionsAndAnglesList(analyzeRightSide, analyzeLeftSide);
	}

	void Update () {
		showVerticesList(meshRightVerticesList, Color.green);
		showVerticesList(meshLeftVerticesList, Color.red);
	}

	//--
	//Init & clean methods
	private void init()
	{
		mesh = GetComponent<MeshFilter>().mesh;
		meshRightVerticesList = new List<Vector3>();
		meshLeftVerticesList = new List<Vector3>();
		meshRightDirectionsAndAngles = new List<Vector2>();
		meshLeftDirectionsAndAngles = new List<Vector2>();
	}

	private void clearAllData()
	{
		mesh = null;
		meshLeftVerticesList.Clear();
		meshRightVerticesList.Clear();
		meshRightDirectionsAndAngles.Clear();
		meshLeftDirectionsAndAngles.Clear();
	}

	//--
	//Computation
	/* Pass 01
	 * Load raw mesh data
	 * Clean mesh indice bug
	 * Fill lists per side
	 * Compute directions and angles. Fill Lists of directions and angles.
	 * */

	private void loadMeshData()
	{
		//Load mesh vertices
		Vector3[] vertices = mesh.vertices;

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

			if(v%2 == 0 && analyzeRightSide == true)
			{
				meshRightVerticesList.Add(vertice);
			}
			if(v%2 != 0 && analyzeLeftSide == true)
			{
				meshLeftVerticesList.Add(vertice);
			}
		}
	}

	private void fillDirectionsAndAnglesList(bool right, bool left)
	{
		if(right)
		{
			meshRightDirectionsAndAngles = computeDirectionAndAngle(meshRightVerticesList);
			Debug.Log(meshRightVerticesList.Count+" "+meshRightDirectionsAndAngles.Count);
		}
		if(left)
		{
			meshLeftDirectionsAndAngles = computeDirectionAndAngle(meshLeftVerticesList);
		}
	}



	//Pass 02

	//Pass 03

	//--
	//Maths Methods
	private List<Vector2> computeDirectionAndAngle(List<Vector3> vecList)
	{
		List<Vector2> dirAndAngles = new List<Vector2>();
		
		dirAndAngles.Add(new Vector2(1, 0)); //add first index
		dirAndAngles.Add(new Vector2(1, 0)); //add second index

		for(int i = 2; i<vecList.Count; i++)
		{
			/*
			 * Angle AB = acos((A.x*B.y + A.y*B.y) / |A|*|B|); ou :
			 * Float d = DP(AB); //(ou A.dot(B) in processing)
			 * Angle AB = acos(d/(A.mag()*B.mag());
			*/

			//Define vertices
			Vector2 A = new Vector2 (vecList[i-2].x, vecList[i-2].z);
			Vector2 B = new Vector2 (vecList[i-1].x, vecList[i-1].z);
			Vector2 C = new Vector2 (vecList[i].x, vecList[i].z);

			//Define length between vertices
			float a = Vector2.Distance(C, B);
			float b = Vector2.Distance(C, A);
			float c = Vector2.Distance(A, B);

			//compute angle via cosine method
			float phi = (Mathf.Acos((Mathf.Pow(a, 2f)+Mathf.Pow(b, 2f)-Mathf.Pow(c, 2f))/(2f*a*b))) * Mathf.Rad2Deg;

			//compute orientation via cross product
			Vector2 BA = A-B;
			Vector2 BC = C-B;
			Vector3 crossBABC = Vector3.Cross(BA, BC);

			int direction = 1; //Straight = 1, left = 0, right = 2

			Color c0 = new Color(0f, 0f, 0f);

			if(phi > bendAt)
			{
				if(crossBABC.z < 0)
				{
					direction = 0;
					//Debug.Log("left");
					c0 = Color.red;
				}
				else if(crossBABC.z > 0)
				{
					direction = 2;
					//Debug.Log("right");
					c0 =  Color.green;
				}
			}
			else
			{
				direction = 0;
				//Debug.Log("Straight");
				c0 =  Color.white;
			}

		

				dirAndAngles.Add(new Vector2(direction, phi));
				//debug
				Vector3 v = vecList[i];
				GameObject clone = Instantiate(objectToInstantiate, v, Quaternion.Euler(new Vector3(0f, phi, 0f))) as GameObject;
				clone.renderer.material.color = c0;

			//Debug.Log(i-1+" : "+phi);
		}

		return dirAndAngles;
	}

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
		Debug.DrawLine(o, v, c); 
	}
	
	private void showVerticesList(List<Vector3> vecList, Color c)
	{
		for(int i = 1; i<vecList.Count; i++)
		{
			showDebugLine(vecList[i-1], vecList[i], c);
		}
	}
	
	private void showNormals(Mesh m)
	{
		Vector3[] vertices = m.vertices;
		Vector3[] normals = m.normals;
		
		//vertices & vertices
		for(int v = 0; v < vertices.Length; v++)
		{
			Vector3 vertice =  transform.position+vertices[v];
			Vector3 normal =  normals[v];
			
			showDebugVector(normal, vertice, 1.5f, Color.magenta);
		}
	}
}
