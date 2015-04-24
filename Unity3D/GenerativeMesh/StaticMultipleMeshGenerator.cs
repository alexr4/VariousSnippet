using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class StaticMultipleMeshGenerator : MonoBehaviour 
{

	private GameObject player;
	private PlayerController pc;

	private MeshFilter mf;
	private Mesh mesh;
	BoxCollider colliderComponent;
	
	//List (Vertices / Triangles / Normals / Uvs)
	private List<Vector3> vertList;
	private List<int> triIndexList;
	private List<Vector3> normList;
	private List<Vector2> uvList;
	private List<Vector3> destination;
	private List<Color> vertColorList;
	
	//parametric variables
	private float length; // Vertical Res of the Spline
	private int resTrail; // Horizontal Res of the Mesh
	private float depthQuad; // Depth of the Quad
	private float widthQuad; // Width of the Quad
	private float minWidth; // Minimum Width for random Radius
	private float maxElevation; // Maximum elevation
	private float underGround; // UnderGround Position for growing (y)

	private List<Vector3> linePoints;
	private List<float> angleList;
	private List<float> radiusList;
	private List<float> elevationList;
	private List<float> maxRadPerLine;
	
	//List plants supplémentaires
	public List<GameObject> plantList;	
	public float secondMeshPercentOfGeneration;
	
	void Start()
	{

		player = GameObject.Find("Player");
		pc = player.GetComponent<PlayerController>();

		initMesh ();

		initVariables ();
		initLists ();
		initLine ();

		computeLine ();
		computeAngle ();
		computeAllVertice ();
		updateMesh ();
		computeSecondMesh();
		//debugLog ();
	}

	//méthods init
	private void initVariables()
	{
		length = (float) Random.Range (3, 6); // Vertical Res of the Spline
		resTrail = (int) length;//Random.Range(2, 6); // Horizontal Res of the Mesh
		if(resTrail%2 != 0)
		{
			resTrail +=1;
		}
		depthQuad = map (length, 6, 0.2f, 1.0f);//(float) Random.Range (2, 10)*0.1f; // Depth of the Quad
		widthQuad = depthQuad;//(float) Random.Range (2, 10)*0.1f; // Width of the Quad
		minWidth = widthQuad; // Minimum Width for random Radius
		maxElevation = (float) Random.Range (1, 2); // Maximum elevation
		underGround = -0.5f; // UnderGround Position for growing (y)

		colliderComponent.size = new Vector3 (widthQuad * resTrail, 1, depthQuad * length);
		colliderComponent.center = new Vector3 (0, 0, (depthQuad * length)/2);
		colliderComponent.isTrigger = true;
	}

	private void initLists()
	{
		vertList = new List<Vector3> ();
		triIndexList = new List<int> ();
		normList = new List<Vector3> ();
		uvList = new List<Vector2> ();
		destination = new List<Vector3> ();
		vertColorList =  new List<Color>();
	}
	
	private void initLine()
	{
		linePoints = new List<Vector3>();
		elevationList = new List<float> ();
		radiusList = new List<float> ();
		maxRadPerLine = new List<float> ();
	}
	
	private void initMesh()
	{
		mf = GetComponent<MeshFilter> ();
		mesh = new Mesh ();
		mf.mesh = mesh;
		colliderComponent = gameObject.AddComponent< BoxCollider >();
	}

	//methods update
	void Update()
	{
		/*if (Input.GetKeyDown ("space")) 
		{
			resetMesh();
			computeSecondMesh();
		} else {
			
			updateMeshElevation ();
			updateMesh();
		}*/
		
		updateMeshElevation ();
		updateMesh();
	}

	private void updateMesh()
	{
		mesh.Clear ();
		mesh.vertices = vertList.ToArray ();
		mesh.triangles = triIndexList.ToArray ();
		mesh.normals = normList.ToArray ();
		mesh.uv = uvList.ToArray ();
		mesh.colors = vertColorList.ToArray();

		mesh.RecalculateNormals ();
		mesh.RecalculateBounds();
		mesh.Optimize();
	}

	private void updateMeshElevation()
	{
		for (int i=0; i<vertList.Count; i++) 
		{
			Vector3 vertex = vertList[i];
			
			float range =  map(pc.getVelocity(), 2, 0.1f, 1f);
			Vector3 dest = new Vector3(destination[i].x, destination[i].y, destination[i].z);

			vertex = Vector3.Lerp(vertex, dest, range);

			vertList[i] = vertex;
		}
		mesh.vertices = vertList.ToArray ();
	}

	//Reset Method
	private void resetMesh()
	{
		linePoints.Clear ();
		elevationList.Clear ();
		radiusList.Clear ();
		maxRadPerLine.Clear ();
		
		vertList.Clear ();
		triIndexList.Clear ();
		normList.Clear ();
		uvList.Clear ();
		destination.Clear ();
		vertColorList.Clear();
		
		mesh.Clear ();
		
		initVariables ();
		initLists ();
		initLine ();
		
		computeLine ();
		computeAngle ();
		computeAllVertice ();
		updateMesh ();
	}


	//Compute Methods
	private void computeLine()
	{
		for (int i=0; i<=length; i++) 
		{
			//define Line variables
			float depth = (i*depthQuad);
			float x = Random.value*widthQuad;
			float y = 0.5f;//Random.value*widthQuad;
			Vector3 tempLoc = new Vector3(x, y, depth);
			//add point position to linePoint
			linePoints.Add(tempLoc);

			//Create elevation & radius Lists;
			float randomRad = minWidth+Random.value*(widthQuad*resTrail)/2;//Random.value*((widthQuad*resTrail)/2);
			maxRadPerLine.Add (randomRad);
			//reel elev here
			for(int j=0; j<=resTrail; j++)
			{
				float randomElev = Random.value*maxElevation;
				//randomElev = map(randomElev, maxElevation, 0.5f, 1f);
				float elev = 0;
				if(j<resTrail/2)
				{
					elev = map (j, resTrail, 0.01f, randomElev);
				}
				else
				{
					elev = map (j, resTrail, randomElev, 0.01f);
				}
				elevationList.Add(elev);


				float rad = map(j, resTrail, randomRad*-1, randomRad);
				//Debug.Log(i+" "+j+" "+Mathf.Abs(rad));
				radiusList.Add(Mathf.Abs(rad));

				//Debug.Log("I = "+i+" J = "+j+" rad = "+rad);
			}
		}
	}

	private void computeAngle()
	{
		angleList = new List<float> ();
		float rho = 0;
		for (int i=0; i<linePoints.Count; i++) 
		{
			Vector3 temp0 = linePoints[i];
			if(i<linePoints.Count-1)
			{
				Vector3 temp1 = linePoints[i+1];

				Vector2 t0 = new Vector2(temp0.x, temp0.z);
				Vector2 t1 = new Vector2(temp1.x, temp1.z);

				//rho = Vector2.Angle(t0, t1);
				rho = getAngleBetween(t0, t1);
				//Debug.Log("Angle Between "+i+" & "+(i+1)+" = "+rho*Mathf.Rad2Deg);
			}
			else
			{
				rho =0;
			}
			angleList.Add(rho);
		}
	}

	private void computeAllVertice()
	{
		for (int i=0; i<linePoints.Count-1; i++) 
		{
			int indexRow0 = i;
			int indexRow1 = i;

			if(i<linePoints.Count-1)
			{
				indexRow1 = i+1;
			}

			Vector3 temp0 = linePoints[indexRow0];
			Vector3 temp1 = linePoints[indexRow1];
			float rho0 = angleList[indexRow0];
			float rho1 = angleList[indexRow1];
			float radLine = maxRadPerLine[indexRow0];

			for(int j= 0; j< resTrail; j++)
			{
				int indexTri = (int)(j*4)+(indexRow0*4*resTrail);//+j*resTrail); //(i*4)

				int i0 = j+(i*resTrail)+i;
				int i1 = j+1+(i*resTrail)+i;
				int i2 = j+resTrail+1+(i*resTrail)+i;
				int i3 = j+resTrail+2+(i*resTrail)+i;

				Vector4 elevation = new Vector4(elevationList[i0], elevationList[i1], elevationList[i2], elevationList[i3]);
				Vector4 radius = new Vector4(radiusList[i0], radiusList[i1],radiusList[i2], radiusList[i3]);

				//Sem
				if(indexRow0 == 0)
				{
					elevation = new Vector4(0, 0, elevationList[i2], elevationList[i3]);
				}

				if(indexRow1 == linePoints.Count-1)
				{
					elevation = new Vector4(elevationList[i0], elevationList[i1], 0, 0);
				}

				computeMesh(temp0, temp1, indexRow0, j, indexTri, rho0, rho1, elevation, radius, radLine);
					
				//Debug.Log(i+" "+j+"       "+i0+" "+i1+" "+i2+" "+i3+"       "+indexTri+"       "+offset);

			}
			//Debug.Log("-----------------NEW LINE-------------");
		}
	}

	private void computeMesh(Vector3 localOrigin0, Vector3 localOrigin1, int indexCenter, int indexTrailLine, int indexForTri, float phi0, float phi1, Vector4 elevation, Vector4 radius, float radLine)
	{
		float uvx0 = 0;
		float uvx1 = 0;
		if (indexTrailLine < resTrail / 2) 
		{
			phi0 = phi0 + Mathf.PI;
			phi1 = phi1 + Mathf.PI;
			
			uvx0 = map (radius.x, radLine, 0.5f, 0);//(1 / resTrail) * indexTrailLine;
			uvx1 = map (radius.y, radLine, 0.5f, 0);
			
		} else {
			//phi0 = phi0;
			//phi1 = phi1;
			uvx0 = map (radius.x, radLine, 0.5f, 1);//(1 / resTrail) * indexTrailLine;
			uvx1 = map (radius.y, radLine, 0.5f, 1);
		}
		
		//float radius = widthQuad / 2;
		
		/*MonoQuad
		 2------------3
		 * *          *
		 *   *   [2]  *
		 *     *      *
		 *       *    *
		 * [1]     *  *
		 *           **
		 0------------1
		 * MultiQuad [NB à decider]
		 * MQ : 5
		 2------------36------------710----------1114----------1518----------19
		 * *          ** *          ** *          ** *          ** *          *
		 *   *   [2]  **   *   [4]  **   *   [6]  **   *   [8]  **   *   [10] *
		 *     *      **     *      **     *      **     *      **     *      *
		 *       *    **       *    **       *    **       *    **       *    *
		 * [1]     *  ** [3]     *  ** [5]     *  ** [7]     *  ** [9]     *  *
		 *           ***           ***           ***           ***           **
		 0------------14------------58------------912-----------1316----------17
		 * MQ : 3
		 2------------36------------710----------11
		 * *          ** *          ** *          *
		 *   *   [2]  **   *   [4]  **   *   [6]  *
		 *     *      **     *      **     *      *
		 *       *    **       *    **       *    *
		 * [1]     *  ** [3]     *  ** [5]     *  *
		 *           ***           ***           **
		 0------------14------------58------------9
		 * */
		//Add destination vector
		Vector3 loc0 = computeSideWalkElevation(new Vector3 (localOrigin0.x + Mathf.Cos (phi0) * radius.x, elevation.x, localOrigin0.z + Mathf.Sin (phi0) * radius.x));
		Vector3 loc1 = computeSideWalkElevation(new Vector3 (localOrigin0.x + Mathf.Cos (phi0) * radius.y, elevation.y, localOrigin0.z + Mathf.Sin (phi0) * radius.y));
		Vector3 loc2 = computeSideWalkElevation(new Vector3 (localOrigin1.x + Mathf.Cos (phi1) * radius.z, elevation.z, localOrigin1.z + Mathf.Sin (phi1) * radius.z));
		Vector3 loc3 = computeSideWalkElevation(new Vector3 (localOrigin1.x + Mathf.Cos (phi1) * radius.w, elevation.w, localOrigin1.z + Mathf.Sin (phi1) * radius.w));
		
		
		destination.Add (loc0);
		destination.Add (loc1);
		destination.Add (loc2);
		destination.Add (loc3);
		
		
		//Vertices
		vertList.Add (new Vector3(loc0.x, underGround, loc0.z));
		vertList.Add (new Vector3(loc1.x, underGround, loc1.z));
		vertList.Add (new Vector3(loc2.x, underGround, loc2.z));
		vertList.Add (new Vector3(loc3.x, underGround, loc3.z));
		
		//Triangles index 
		/* ClockWise way
		 * Triangle1 : i, i+2, i+1
		 * Triangle2 : i+2, i+3, i+1
		 * */
			triIndexList.Add (indexForTri);
			triIndexList.Add (indexForTri + 2);
			triIndexList.Add (indexForTri + 1);
			
			triIndexList.Add (indexForTri + 2);
			triIndexList.Add (indexForTri + 3);
			triIndexList.Add (indexForTri + 1);

		//Normals
		normList.Add (-Vector3.forward);
		normList.Add (-Vector3.forward);
		normList.Add (-Vector3.forward);
		normList.Add (-Vector3.forward);
		
		//UVs
		float uvy0 = map (indexCenter, length, 0, 1);//(1 / length) * indexCenter;
		float uvy1 = uvy0 + (1 / length);
		
		/*mosaic UV*/
		/*
			uvList.Add (new Vector2 (0,0));
			uvList.Add (new Vector2 (1,0));
			uvList.Add (new Vector2 (0,1));
			uvList.Add (new Vector2 (1,1));
			*/
		/*UV Repeat Y*/
		/*
			uvList.Add (new Vector2 (0,uvy0));
			uvList.Add (new Vector2 (1,uvy0));
			uvList.Add (new Vector2 (0,uvy1));
			uvList.Add (new Vector2 (1,uvy1));
			*/
		/*UV Repeat X*/
		/*
			uvList.Add (new Vector2 (uvx0,0));
			uvList.Add (new Vector2 (uvx1,0));
			uvList.Add (new Vector2 (uvx0,1));
			uvList.Add (new Vector2 (uvx1,1));
			*/
		/*UV Complet*/
		
		uvList.Add (new Vector2 (uvx0,uvy0));
		uvList.Add (new Vector2 (uvx1,uvy0));
		uvList.Add (new Vector2 (uvx0,uvy1));
		uvList.Add (new Vector2 (uvx1,uvy1));
		
		//vertex color one random per vertex
		/*
		Color vertColor00 = new Color(Random.Range(0f, 1f), Random.Range(0f, 1f), Random.Range(0f, 1f), 1f);
		Color vertColor01 = new Color(Random.Range(0f, 1f), Random.Range(0f, 1f), Random.Range(0f, 1f), 1f);
		Color vertColor02 = new Color(Random.Range(0f, 1f), Random.Range(0f, 1f), Random.Range(0f, 1f), 1f);
		Color vertColor03 = new Color(Random.Range(0f, 1f), Random.Range(0f, 1f), Random.Range(0f, 1f), 1f);
		*/
		//Vertex color one random per quad
		Color vertColor = new Color(0f, Random.Range(0.0f, 1f), Random.Range(0.0f, 1f), 1f);
		
		vertColorList.Add(vertColor);
		vertColorList.Add(vertColor);
		vertColorList.Add(vertColor);
		vertColorList.Add(vertColor);
	}
	
	private void computeSecondMesh()
	{
		float probabilities = Random.value;
		//Debug.Log(probabilities);
		if (probabilities > 1-(secondMeshPercentOfGeneration*0.01)) 
		{
			//Find Mesh
			int probabilities2 = Mathf.RoundToInt(Random.Range(0,4));
			//Find Location
			Vector3 loc = transform.position + linePoints[linePoints.Count/2];
			
			if(loc.x > pc.getBorderRight() || loc.x < pc.getBorderLeft())
			{
				loc.y = pc.getOffsetY();
			}
			else{
				loc.y = 0f;
			}
			/*loc.x += linePoints[linePoints.Count/2].x;
			loc.z += linePoints[linePoints.Count/2].z;*/
			//loc.y = 0f;
			//Instantiate
			Instantiate (plantList[probabilities2], loc, Quaternion.identity);
		}
	}


	//Methods Get
	private float getAngleBetween(Vector2 l0, Vector2 l1)
	{
		float adjacent = l1.x-l0.x;
		float opposed = l1.y-l0.y;
		float beta = Mathf.Atan2(opposed, adjacent);
		beta = beta - (Mathf.PI / 2);

		return beta;
	}

	private float map(float i, float max, float nMin, float nMax)
	{
		return Mathf.Lerp(nMin, nMax, (float)i/max);
	}
	
	private Vector3 computeSideWalkElevation(Vector3 loc)
	{
		if((transform.position.x+loc.x) > pc.getBorderRight() || (transform.position.x+loc.x) < pc.getBorderLeft())
		{
			loc.y += pc.getOffsetY()-0.1f;
		}
		else{
		}
		
		return loc;
	}

	private void debugLog()
	{
		Debug.Log ("LinePoint.Count : " + linePoints.Count);
		Debug.Log ("AngleList.Count : " + angleList.Count);
		Debug.Log ("RadiusList.Count : " + radiusList.Count);
		Debug.Log("Elevation.Count : "+elevationList.Count);
		Debug.Log ("resTrail : " + resTrail);

		Debug.Log("\tmesh.VertexList : "+vertList.Count);
		Debug.Log("\tmesh.TrianglesList : "+triIndexList.Count);
		Debug.Log("\tmesh.NormalsList : "+normList.Count);
		Debug.Log("\tmesh.UVList : "+uvList.Count);
	}
}
