using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DynamicMeshGenerator : MonoBehaviour 
{
	private GameObject player;
	private PlayerController pc;
	private Vector3 pastLocation;

	//Mesh
	private MeshFilter mf;
	private Mesh mesh;
	
	//Mesh List (Vertices / Triangles / Normals / Uvs)
	private List<Vector3> vertList;
	private List<int> triIndexList;
	private List<Vector3> normList;
	private List<Vector2> uvList;
	private List<Vector3> destination;
	private List<Color> vertColorList;
	
	//parametric variables
	public float distanceFromPlayer;
	public float length;
	public float depthQuad;
	public float widthQuad;
	public float minWidth;
	public float maxElevation;
	public int resTrail;
	public float underGround;
	public float speedElev;
	public bool staticDepth;
	private List<Vector3> linePoints;
	private List<float> angleList;
	private List<float> radiusList;
	private List<float> elevationList;
	private List<float> maxRadPerLine;
	private float maxRad;
	private int indexRow0;
	private int indexRow1;

	//Fixed Vegetation
	public GameObject fixedMesh;
	public float secondMeshPercentOfGeneration;
	
	//List plants supplémentaires
	public List<GameObject> plantList;	
	public float plantPercentOfGeneration;
	private List<int> indexRowVertexForPlant0;
	private List<int> indexRowVertexForPlant1;

	//DebugCube
	public GameObject debugShape;
	
	void Start()
	{
		
		player = GameObject.Find("Player");
		pc = player.GetComponent<PlayerController>();

		initLists ();
		initMesh ();
		initLine ();
		initPlayer ();
		initOtherMeshes ();
	}

	//Update Globale
	void Update()
	{
		if (hasPlayerMoved ()) {
			//debugLog ();
			if (linePoints.Count > length) {
				cleanLineList ();
				cleanMeshList();
			} else {
			}

			//Vector point from PL et L
			if(staticDepth)
			{
				Vector3 loc = player.transform.position;
				if (linePoints.Count > 0) {
					Vector3 dir = player.transform.position - linePoints [linePoints.Count - 1];
					dir = dir.normalized;
					dir = Vector3.ClampMagnitude (dir, depthQuad);
				
					loc = linePoints [linePoints.Count - 1] + dir;
				} else {
				}
				linePoints.Add (loc);
			}
			else
			{
				linePoints.Add(player.transform.position);
			}
			computeLine ();
			computeAngle (pastLocation, player.transform.position);
			computeAllVertice ();

			computeSecondMesh();
			computePlant();

			pastLocation = player.transform.position;
		} else {
		}
		
		updateMeshElevation ();
		updateMesh ();

	}

	//InitMethods
	private void initPlayer()
	{
		pastLocation = player.transform.position;
	}
	
	private void initLine()
	{
		indexRow0 = 0;
		indexRow1 = 1;
		linePoints = new List<Vector3>();
		angleList = new List<float> ();
		elevationList = new List<float> ();
		radiusList = new List<float> ();
		maxRadPerLine = new List<float> ();
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
	
	private void initMesh()
	{
		mf = GetComponent<MeshFilter> ();
		mesh = new Mesh ();
		mf.mesh = mesh;
	}

	private void initOtherMeshes()
	{
		indexRowVertexForPlant0 = new List<int>();
		indexRowVertexForPlant1 = new List<int>();
		
		int index0 = 0;
		int index1 = 4;
		
		for(int i = 0; i<=resTrail; i++)
		{
			indexRowVertexForPlant0.Add(index0);
			indexRowVertexForPlant1.Add(index1);
			
			index0 += 4;
			index1 += 4;
		}
	}

	//Methods Update
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

	private void cleanLineList()
	{
		indexRow0 --;
		indexRow1 --;
		linePoints.RemoveAt (0);
		angleList.RemoveAt (0);
		maxRadPerLine.RemoveAt (0);

		for (int j=0; j<=resTrail; j++) 
		{
			radiusList.RemoveAt(j);
			elevationList.RemoveAt(j);
		}

	}

	private void cleanMeshList()
	{
		vertList.RemoveRange(0, resTrail*4);
		vertColorList.RemoveRange(0, resTrail*4);
		normList.RemoveRange(0, resTrail*4);
		uvList.RemoveRange(0, resTrail*4);

		destination.RemoveRange (0, resTrail*4);

		for (int i=0; i<uvList.Count; i++) 
		{
			Vector2 newUV = new Vector2(0, 1/length);
			uvList[i] = uvList[i]-newUV;
		}

	}

	private void updateMeshElevation()
	{
		//rangeUpdate ();
		for (int i=0; i<vertList.Count; i++) 
		{
			Vector3 vertex = vertList[i];

			float range =  map(pc.getVelocity(), 2, 0.1f, 1f);
			Vector3 dest = new Vector3(destination[i].x, destination[i].y, destination[i].z);

			vertex = Vector3.Lerp(vertex, dest, range);

			vertList[i] = vertex;
		}
	}


	//Computation Methods
	private void computeLine()
	{
		//Create elevation & radius Lists;
		maxRad = minWidth+Random.value*(widthQuad*resTrail)/2;//Random.value*((widthQuad*resTrail)/2);
		maxRadPerLine.Add (maxRad);
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
				
				
			float rad = map(j, resTrail, maxRad*-1, maxRad);
			//Debug.Log(i+" "+j+" "+Mathf.Abs(rad));
			radiusList.Add(Mathf.Abs(rad));
			//Debug.Log("I = "+i+" J = "+j+" rad = "+rad);
		}


	}
	
	private void computeAngle(Vector3 from, Vector3 to)
	{
		Vector2 t0 = new Vector2(from.x, from.z);
		Vector2 t1 = new Vector2(to.x, to.z);

		float rho = getAngleBetween(t0, t1);
		//Debug.Log (rho);
		angleList.Add(rho);
	}

	private void computeAllVertice()
	{
		if (linePoints.Count > 1) 
		{
			Vector3 temp0 = linePoints[indexRow0];
			Vector3 temp1 = linePoints[indexRow1];
			float rho0 = angleList[indexRow0];
			float rho1 = angleList[indexRow1];
			float radLine = maxRadPerLine[indexRow0];

			for(int j= 0; j< resTrail; j++)
			{
				int indexTri = (int)(j*4)+(indexRow0*4*resTrail);//+j*resTrail); //(i*4)
				
				int i0 = j+(indexRow0*resTrail)+indexRow0;
				int i1 = j+1+(indexRow0*resTrail)+indexRow0;
				int i2 = j+resTrail+1+(indexRow0*resTrail)+indexRow0;
				int i3 = j+resTrail+2+(indexRow0*resTrail)+indexRow0;
				
				Vector4 elevation = new Vector4(elevationList[i0], elevationList[i1], elevationList[i2], elevationList[i3]);
				if(indexRow0 == 0)
				{
					elevation = new Vector4(0, 0, elevationList[i2], elevationList[i3]);
				}
				Vector4 radius = new Vector4(radiusList[i0], radiusList[i1],radiusList[i2], radiusList[i3]);
				
				computeMesh(temp0, temp1, indexRow0, j, indexTri, rho0, rho1, elevation, radius, radLine);
				
				//Debug.Log(i+" "+j+"       "+i0+" "+i1+" "+i2+" "+i3+"       "+indexTri+"       "+offset);
			}

			indexRow0 ++;
			indexRow1 ++;
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
		/*
		Vector3 loc0 = new Vector3 (localOrigin0.x + Mathf.Cos (phi0) * radius.x, elevation.x, localOrigin0.z + Mathf.Sin (phi0) * radius.x);
		Vector3 loc1 = new Vector3 (localOrigin0.x + Mathf.Cos (phi0) * radius.y, elevation.y, localOrigin0.z + Mathf.Sin (phi0) * radius.y);
		Vector3 loc2 = new Vector3 (localOrigin1.x + Mathf.Cos (phi1) * radius.z, elevation.z, localOrigin1.z + Mathf.Sin (phi1) * radius.z);
		Vector3 loc3 = new Vector3 (localOrigin1.x + Mathf.Cos (phi1) * radius.w, elevation.w, localOrigin1.z + Mathf.Sin (phi1) * radius.w);
		*/
		
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
		if (linePoints.Count <= length) {
			triIndexList.Add (indexForTri);
			triIndexList.Add (indexForTri + 2);
			triIndexList.Add (indexForTri + 1);
		
			triIndexList.Add (indexForTri + 2);
			triIndexList.Add (indexForTri + 3);
			triIndexList.Add (indexForTri + 1);

		}

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
		Color vertColor = new Color(0f, Random.Range(0.0f, 1.0f), Random.Range(0.0f, 1.0f), 1f);//Random.Range(0.0f, 1f), Random.Range(0.0f, 1f), 1f);
		
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
			float probabilities2 = Random.value;
			Vector3 tl = new Vector3(0,0,0);
			float marge = Random.Range(5, 10);
			
			if(probabilities2 > 0.5)
			{
				tl = new Vector3 (pastLocation.x - marge, 0, pastLocation.z);
			}
			else{
				tl = new Vector3 (pastLocation.x + marge, 0, pastLocation.z);
			}
			
			Instantiate (fixedMesh, tl, Quaternion.identity);
		}
	}
	
	private void computePlant()
	{
		if(linePoints.Count > 4)
		{
			float probabilities = Random.value;
			//Debug.Log(probabilities);
			if (probabilities > 1-(plantPercentOfGeneration*0.01)) 
			{
				//Find Mesh
				int probabilities2 = Mathf.RoundToInt(Random.Range(0,4));
				//Find Location
				int indexVertex0 = Random.Range(indexRowVertexForPlant0[0], indexRowVertexForPlant0[indexRowVertexForPlant0.Count-1]);
				int indexVertex1 = Random.Range(indexRowVertexForPlant1[0], indexRowVertexForPlant0[indexRowVertexForPlant1.Count-1]);
				
				Vector3 loc =  Vector3.Lerp(destination[(destination.Count-1)-(resTrail*4)+indexVertex1], destination[(destination.Count-1)-(resTrail*4)+indexVertex0], 0.5f);
				
				if(loc.x > pc.getBorderRight() || loc.x < pc.getBorderLeft())
				{
					loc.y = pc.getOffsetY();
				}
				else{
					loc.y = 0f;
				}
				
				//Instantiate
				Instantiate (plantList[probabilities2], loc, Quaternion.identity);
			}
		}
	}

	//Math Methods & Get Methods
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

	private bool hasPlayerMoved()
	{
		float distanceBeetweenOP = Vector3.Distance(player.transform.position, pastLocation);

		if (distanceBeetweenOP >= distanceFromPlayer) {
			return true;
		} else {
			return false;
		}
	}
	
	private Vector3 computeSideWalkElevation(Vector3 loc)
	{
		if(loc.x > pc.getBorderRight() || loc.x < pc.getBorderLeft())
		{
			loc.y += pc.getOffsetY()-0.1f;
		}
		else{
		}
		
		return loc;
	}

	//Debug Methods
	private void debugLog()
	{

		Debug.Log ("indexRow0 : " + indexRow0);	
		Debug.Log ("indexRow1 : " + indexRow1);

		Debug.Log ("LinePoint.Count : " + linePoints.Count);
		Debug.Log ("resTrail : " + resTrail);
		Debug.Log ("AngleList.Count : " + angleList.Count);
		Debug.Log ("RadiusList.Count : " + radiusList.Count);
		Debug.Log ("Elevation.Count : "+elevationList.Count);

		Debug.Log("\tmesh.VertexList : "+vertList.Count);
		Debug.Log("\tmesh.TrianglesList : "+triIndexList.Count);
		Debug.Log("\tmesh.NormalsList : "+normList.Count);
		Debug.Log("\tmesh.UVList : "+uvList.Count);

		/*
		for (int i=0; i<vertList.Count; i++) 
		{
			if(i%(4*resTrail) == 0)
			{
				Debug.Log("\t\t---- New Line ----");
			}
			Debug.Log("\t\tvertex "+i+" y : "+vertList[i].y+" > "+verticalDest[i]);
		}
		*/
		/*
		for (int i=0; i<triIndexList.Count; i++) 
		{
			if(i%(6*resTrail) == 0)
			{
				Debug.Log("\t\t---- New Line ----");
			}
			Debug.Log("\t\ttriIndex"+i+" : "+triIndexList[i]);
		}
		*/
		Debug.Log("-------------------------------");
	}
}
