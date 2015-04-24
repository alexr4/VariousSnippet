using UnityEngine;
using System.Collections;

public class NewPerlin2 : MonoBehaviour
{
	/*Perlin noise
	 * Ken Perlin's Improved Noise Algorithm
	 * See http://mrl.nyu.edu/~perlin/paper445.pdf
	 * converted to Unity by Unity coder : http://unitycoder.com/blog/2012/04/12/improved-perlin-noise-algorithm/
	 * Update by Bonjour, intercative lab
	 * August 2014
	 * */

	private int x,y;
	private float z;
	private Texture2D texture;
	private float z2;
	private int[] p = new int[512];
	private Color32[] cols;

	public int width = 128;
	public int height = 128;
	[Range(0.0f, 0.1f)]
	public float speedZ = 0.02f;
	[Range(0.0f, Mathf.PI*2)]
	public float speedAngle = Mathf.PI*2;
	[Range(0.0f, 0.5f)]
	public float noiseScale = 0.03f;
	[Range(0.0f, 64)]
	public float scaleY = 0;
	public Texture2D _MainTex;
	public Texture2D _SecondTex;

	
	void Start () 
	{
		texture = new Texture2D(width, height);
		renderer.material.shader = Shader.Find("Custom/PerlinShader");
		renderer.material.SetTexture("_MainTex", _MainTex);
		renderer.material.SetTexture("_SecondTex", _SecondTex);
		cols = new Color32[width*height];
		setupPermutationTable();
		z = 0;
	}
	
	void Update () 
	{
		for (y = 0; y<height; y++)
		{
			for (x = 0; x<width; x++)
			{
				float c = Mathf.Clamp(newNoise(x*noiseScale, y*noiseScale, z*noiseScale)*speedAngle, 0f, 1f);

				if(y <= scaleY)
				{
					c = 0;
				}
				else if(y > scaleY && y<= height/2)
				{
					c = c - MathfMap(y, scaleY, height/2, 1, 0);
				}
				else if(y > height/2 && y <= height - scaleY)
				{
					c = c - MathfMap(y, height/2, height - scaleY, 0, 1);
				}
				else if(y >= height - scaleY)
				{
					c = 0;
				}
				cols[x+y*width] = new Color(c,c,c,1);		
			}
			
			z+=speedZ;
		}
		texture.SetPixels32(cols);

		renderer.material.SetTexture("_PerlinTex", texture);
		texture.Apply(false);
	}
	
	
	private float newNoise(float x, float y, float z) 
	{
		int X = (int)Mathf.Floor(x) & 255;
		int Y = (int)Mathf.Floor(y) & 255;
		int Z = (int)Mathf.Floor(z) & 255;
		x -= Mathf.Floor(x);
		y -= Mathf.Floor(y);
		z -= Mathf.Floor(z);
		float u = fade(x);
		float v = fade(y);
		float w = fade(z);   
		int A = p[X]+Y;
		int AA = p[A]+Z;
		int AB = p[A+1]+Z;
		int B = p[X+1]+Y;
		int BA = p[B]+Z;
		int BB = p[B+1]+Z;

		return lerp2(w, lerp2(v, lerp2(u, grad(p[AA], x, y, z), grad(p[BA], x-1, y, z)),
				lerp2(u, grad(p[AB], x, y-1, z), grad(p[BB], x-1, y-1, z))),
				lerp2(v, lerp2(u, grad(p[AA+1], x, y, z-1), grad(p[BA+1], x-1, y, z-1)),
				lerp2(u, grad(p[AB+1], x, y-1, z-1), grad(p[BB+1], x-1, y-1, z-1))));
	}

	private float fade(float t) 
	{
  		return ((t*6 - 15)*t + 10)*t*t*t;
 	}
 
	private float lerp2(float t, float a, float b) 
	{
		return (b - a)*t + a;
	}
 
	private float grad(int hash, float x, float y, float z) 
	{
		int h = hash & 15;
		float u = h<8 ? x : y;
		float v = h<4 ? y : h==12||h==14 ? x : z;
		return ((h&1) == 0 ? u : -u) + ((h&2) == 0 ? v : -v);
	}
 
	private void setupPermutationTable() 
 	{
	 
	  int[] permutation = new int[] {151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194,
	      233, 7, 225, 140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190,
	      6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35,
	      11, 32, 57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168,
	      68, 175, 74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111,
	      229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102,
	      143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18,
	      169, 200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186,
	      3, 64, 52, 217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82,
	      85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183,
	      170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167,
	      43, 172, 9, 129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178,
	      185, 112, 104, 218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12,
	      191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239, 107, 49, 192, 214,
	      31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150,
	      254, 138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78,
	      66, 215, 61, 156, 180};
	  	for (int i=0; i < 256 ; i++)
		{
	    	p[i] = p[i+256] = permutation[i];
		}
	}

	//--
	//Maths Methods
	private float MathfMap(float value, float start1, float stop1, float start2, float stop2) 
	{
		return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1));
	}
}
