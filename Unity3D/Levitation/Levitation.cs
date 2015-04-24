using UnityEngine;
using System.Collections;

public class Levitation : MonoBehaviour {

	public float levitationForce;
	public string[] tagToAvoide;

	void OnTriggerEnter(Collider other)
	{
		if(tagToAvoide.Length > 0)
		{
			for(int i=0; i< tagToAvoide.Length; i++)
			{
				if(other.tag != tagToAvoide[i])
				{
					other.rigidbody.velocity = Vector3.zero;
				}
			}
		}
		else
		{
			other.rigidbody.velocity = Vector3.zero;
		}
	}

	void OnTriggerStay(Collider other)
	{
		if(tagToAvoide.Length > 0)
		{
			for(int i=0; i< tagToAvoide.Length; i++)
			{
				if(other.tag != tagToAvoide[i])
				{
					other.rigidbody.AddForce(Vector3.up * levitationForce, ForceMode.Acceleration);
				}
			}
		}
		else
		{
			other.rigidbody.AddForce(Vector3.up * levitationForce, ForceMode.Acceleration);
		}
	}

	void OnTriggerExit(Collider other)
	{
		if(tagToAvoide.Length > 0)
		{
			for(int i=0; i< tagToAvoide.Length; i++)
			{
				if(other.tag != tagToAvoide[i])
				{
					//other.rigidbody.velocity = Vector3.zero;
				}
			}
		}
		else
		{
			//other.rigidbody.velocity = Vector3.zero;
		}
	}
}
