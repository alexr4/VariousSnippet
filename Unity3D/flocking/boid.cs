using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class boid : MonoBehaviour {
	/*Boid agent - implementation of Craig Reynolds flocking boids behaviors.
	 * Inspired by processing implementation by Daniel Schiffman and Cinder implementation by Robert Hodgin
	 * C# implementation in Unity by Bonjour, intercative Lab
	 * August 2014
	 * --
	 * This implementation use the Collider property to define the FOV of the Agent. 
	 * This is a 360° FOV so it's note really accurate. A more acurate methode will be using a cone shape as a collider for the boid.
	 * Each agent can count how many neighbors he has using the OnTriggerEnter and OnTriggerExit methods and add it to a List of neighbors
	 * Each agent can decide what to do with his neighbors during the flock() method :
	 * 		- The boid is seek by the average position of the flockmates 
	 * 		- The boid direction is toward the average direction of the flockmates
	 * 		- The Boid avoid the other flockmate
	 * Each forces can be prioritize by a forceWeight
	 * 
	 * Other behaviors has been add such has :
	 * 		- A focus weight : Each boid can focus his behaviors on a limited number of flockmates in order to creates small groups
	 * 		- A global objectif : if a boid doesn't has a neighbor he seek a specific space coordinate
	 * 		- A world boundarie : when the boid quit the world, he has to return in the world without focusing on flockmates
	 * 		- An arrive methode to change the global objectif
	 * 
	 * -- To do :
	 * Add a leader boid
	 * Add disturbance boid
	 * */
	
	//Boid's Variables
	private int id;
	private SphereCollider boidCollider;
	private float colliderRadius;
	private Vector3 boidVel;
	private Vector3 boidAcc;
	private Vector3 separationForce;
	private Vector3 alignementForce;
	private Vector3 cohesionForce;
	private Vector3 avoidanceForce;
	private List<Collider> neighborsList;
	private bool flockState;
	private Vector3 flockingOriginCopy;
	private bool arrived;
	
	public float maxSpeed; //Maximum speed of the steering force
	public float maxForce; //Maximum speed of torque force
	public float cohesionWeight;
	public float alignementWeight;
	public float separationWeight;
	public float avoidanceWeight;
	public Vector3 flockingOrigin;
	public int numberMaxOfNeighbors;
	public bool debugMode;
	
	// Use this for initialization
	void Awake()
	{
		init ();
	}

	void Start () {
	}

	//--
	// Update & rotation
	void FixedUpdate () {
		/*Euler implementation
		 * velocity += acceleration
		 * limit velocity to maxSpeed
		 * location += velocity
		 * acceleration *= 0; //reset acceleration
		 */

		flock();
		avoide();

		boidVel += boidAcc;
		boidVel =  Vector3.ClampMagnitude(boidVel, maxSpeed);
		rigidbody.AddForce(boidVel, ForceMode.Force);
		rigidbody.velocity = Vector3.ClampMagnitude(rigidbody.velocity, maxSpeed);
		computeRotation();
		boidAcc *= 0;

		if(debugMode == true)
		{
			showDebug ();
		}
	}

	private void computeRotation()
	{
		if (rigidbody.velocity != Vector3.zero)
		{
			Quaternion rotation = Quaternion.LookRotation(rigidbody.rigidbody.velocity*-1);
			rigidbody.transform.rotation = Quaternion.Slerp(transform.rotation, rotation, maxForce * Time.deltaTime);
		}
		else
		{
			transform.rotation = Quaternion.Euler(Vector3.zero);
		}
	}

	//--
	//init methods
	private void init()
	{
		boidVel = new Vector3(Random.Range(-5.0f, 5.0f), Random.Range(-5.0f, 5.0f), Random.Range(-5.0f, 5.0f));
		boidAcc = Vector3.zero;
		neighborsList = new List<Collider>();
		flockState = true;
		flockingOriginCopy = flockingOrigin;
		boidCollider = GetComponent<SphereCollider> ();
		colliderRadius = boidCollider.radius;

		/*separationForce = rigidbody.transform.position;
		alignementForce = rigidbody.transform.position;
		cohesionForce = rigidbody.transform.position;*/
	}
	
	//--
	//Steering Behaviors (Separation, Alignement, Cohesion)
	void OnTriggerEnter(Collider other) {
		if(other.gameObject.tag == "world")
		{
			flockState = true;
		}

		if(flockState == true)
		{
			if(other.gameObject.tag == "boid" && neighborsList.Count < numberMaxOfNeighbors)
			{
				neighborsList.Add(other);
			}
		}

	}

	void OnTriggerStay(Collider other)
	{
		if(other.gameObject.tag == "obstacle")
		{
			addForce(avoidanceForce);
		}
	}
	
	void OnTriggerExit(Collider other) {
		if(other.gameObject.tag == "boid")
		{
			neighborsList.Remove(other);
		}

		if(other.gameObject.tag == "world")
		{
			//Debug.Log("Yo John, ici boid "+id+", faut qu'on change de position on est hors radar là");
			flockState = false;
			neighborsList.Clear();

		}
	}
	
	private void flock() {

		separationForce = separate();
		alignementForce = align();
		cohesionForce = cohesion();

		Vector3 seekToPoint = seekForce(flockingOrigin);
		seekToPoint.Normalize();

		separationForce.Normalize();
		alignementForce.Normalize();
		cohesionForce.Normalize();

		if(neighborsList.Count > 0)
		{
			addForce(separationForce*separationWeight);
			addForce(alignementForce*alignementWeight);
			addForce(cohesionForce*cohesionWeight);
		}
		else 
		{
			addForce(seekToPoint);
		}

		
		/*
		Debug.Log("boid "+id+" separationForce : "+separationForce);
		Debug.Log("boid "+id+" alignementForce : "+alignementForce);
		Debug.Log("boid "+id+" cohesionForce : "+cohesionForce);
		*/
	}

	public void arriveAt(Vector3 desired_)
	{
		if(desired_ != flockingOrigin)
		{
			setFlockState(false);
			setFlockingOrigin(desired_);
			arrived = false;
		}

		float dist = Vector3.Distance(rigidbody.transform.position, flockingOrigin);
		if(dist <= 5)
		{
			setFlockState(true);
			arrived = true;
			//setFlockingOrigin(flockingOriginCopy);
		}
		else{
			arrived = false;
		}
	}


	
	//--
	//Forces Methods
	public void addForce(Vector3 Force)
	{
		Vector3 computedForce = Force;// / mass;
		boidAcc = boidAcc + computedForce;
	}
	
	public Vector3 seekForce(Vector3 target)
	{
		/*seek method from Craig Reynold behavior where
		 * desired = target - location
		 * desired is normalized
		 * then multiply by maxSpeed
		 * Steer = desired - velocity;
		 * Steer is limited to maxSpeed;
		 * steer is apply to the agent
		 * */
		Vector3 desired = target - transform.position;
		desired.Normalize ();
		desired *= maxSpeed;
		
		Vector3 steer = desired - boidVel;
		steer = Vector3.ClampMagnitude(steer, maxForce);
		
		return steer;
	}
	
	private Vector3 separate()
	{
		if (neighborsList.Count > 0) 
		{
			Vector3 steer = Vector3.zero;
			
			foreach(Collider neighbors in neighborsList)
			{
				float distanceBetweenBoids = Vector3.Distance(rigidbody.transform.position, neighbors.rigidbody.transform.position);
				Vector3 diff = rigidbody.transform.position - neighbors.rigidbody.transform.position;
				diff.Normalize();
				diff = diff/distanceBetweenBoids;
				steer += diff;
			}
			
			
			steer = steer/neighborsList.Count;
			steer.Normalize ();
			steer = steer * maxSpeed;
			steer -= rigidbody.velocity;
			steer = Vector3.ClampMagnitude(steer, maxForce);
			
			
			return steer;
		}
		else{
			return separationForce;
		}
		
	}
	
	private Vector3 align ()
	{
		if (neighborsList.Count > 0) 
		{
			Vector3 steer = Vector3.zero;
			
			foreach (Collider neighbors in neighborsList) 
			{
				steer += neighbors.rigidbody.velocity;
			}
			
			
			
			steer = steer / neighborsList.Count;	
			steer.Normalize ();
			steer = steer * maxSpeed;
			steer -= rigidbody.velocity;
			steer = Vector3.ClampMagnitude(steer, maxForce);
			
			return steer;
			
		}
		else
		{
			return alignementForce;
		}
	}


	private Vector3 cohesion()
	{
		if(neighborsList.Count > 0)
		{
			Vector3 steer = Vector3.zero;
			
			foreach (Collider neighbors in neighborsList) 
			{
				steer += neighbors.rigidbody.transform.position;
			}
			
			steer = steer / neighborsList.Count;
			return seekForce (steer);
		}
		else
		{
			return cohesionForce;
		}
	}

	private void avoide()
	{
		RaycastHit hit;

		if (Physics.Raycast(rigidbody.transform.position, rigidbody.velocity.normalized, out hit, colliderRadius*avoidanceWeight))
		{
			if(hit.collider.tag == "obstacle")
			{
				avoidanceForce = Vector3.zero;
				//Debug.Log("There is something in front of the boid "+getId()+" impact at "+hit.point+" "+hit.collider.tag);
				//setFlockState(false);
				Vector3 diff = hit.point;
				diff.Normalize();
				diff *= colliderRadius*2;//= dir/diff.magnitude;
				avoidanceForce = rigidbody.transform.position + diff;
				avoidanceForce.Normalize();
				avoidanceForce *= avoidanceWeight;

				addForce(avoidanceForce);

				if(debugMode)
				{
					Debug.DrawLine(rigidbody.transform.position, rigidbody.transform.position+diff, Color.cyan);
				}
			}
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
	public void showDebug()
	{	
		Vector3 vel = rigidbody.velocity.normalized;
		vel *= 1.25f;
		vel += rigidbody.transform.position;
		Vector3 sep = rigidbody.transform.position+separationForce;
		Vector3 coh = rigidbody.transform.position+cohesionForce;
		Vector3 ali = rigidbody.transform.position+alignementForce;

		Debug.DrawLine(rigidbody.transform.position, vel, Color.yellow); // Velocity Vector
		Debug.DrawLine(rigidbody.transform.position, sep, Color.green);     // Separation Vector
		Debug.DrawLine(rigidbody.transform.position, coh, Color.magenta);		// Cohesion Vector
		Debug.DrawLine(rigidbody.transform.position, ali, Color.blue);      // Alignement Vector	

		foreach(Collider nei in neighborsList)
		{
			Debug.DrawLine(rigidbody.transform.position, nei.rigidbody.transform.position, Color.red); // Velocity Vector
		}
	}

	//--
	//Get methods
	public int getId()
	{
		return id;
	}

	public Vector3 getVelocity()
	{
		return rigidbody.velocity;
	}

	public Vector3 getAcceleration()
	{
		return boidAcc;
	}

	public Vector3 getSeparationForce()
	{
		return separationForce;
	}

	public Vector3 getAlignementForce()
	{
		return alignementForce;
	}

	public Vector3 getCohesionForce()
	{
		return cohesionForce;
	}

	public List<Collider> getNeighborsList()
	{
		return neighborsList;
	}

	public bool getFlockState()
	{
		return flockState;
	}

	public float getMaxSpeed()
	{
		return maxSpeed;
	}

	public float getMaxForce()
	{
		return maxForce;
	}

	public float getCohesionWeight()
	{
		return cohesionWeight;
	}

	public float getAlignementWeight()
	{
		return alignementWeight;
	}

	public float getSeparationWeight()
	{
		return separationWeight;
	}

	public Vector3 getFlockingOrigin()
	{
		return flockingOrigin;
	}

	public int getNumberMaxOfNeighbors()
	{
		return numberMaxOfNeighbors;
	}

	public bool getDegugMode()
	{
		return debugMode;
	}

	public bool isArrived()
	{
		return arrived;
	}

	//--
	// Set Methods
	public void setId(int id_)
	{
		id = id_;
	}
	
	public void setFlockState(bool state_)
	{
		flockState = state_;
	}
	
	public void setMaxSpeed(float ms_)
	{
		maxSpeed = ms_;
	}
	
	public void setMaxForce(float mf_)
	{
		maxForce =  mf_;
	}
	
	public void setCohesionWeight(float cw_)
	{
		cohesionWeight = cw_;
	}
	
	public void setAlignementWeight(float aw_)
	{
		alignementWeight = aw_;
	}
	
	public void setSeparationWeight(float sw_)
	{
		separationWeight = sw_;
	}
	
	public void setFlockingOrigin(Vector3 fo_)
	{
		flockingOrigin = fo_;
	}
	
	public void setNumberMaxOfNeighbors(int maxnei_)
	{
		numberMaxOfNeighbors = maxnei_;
	}
	
	public void setDegugMode(bool state_)
	{
		debugMode = state_;
	}
}