using UnityEngine;
using System.Collections;

public class animationController : MonoBehaviour {

	Animator ani;
	public float minSpeed;
	public float maxSpeed;

	void Awake () {
		ani = GetComponent<Animator>();
		ani.speed = Random.Range(minSpeed, maxSpeed);
	}

}
