class PointMesh {

  PVector location;
  PVector origine;
  PVector target;
  PVector globalCenter;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  float mass;

  PointMesh(float x, float y, float z) {
    location = new PVector(x, y, z);
    origine = location.get();
    target = origine.get();
    globalCenter = new PVector(0, 0, 0);
    r = 12;
    mass = random(3, 5);
    maxspeed = random(50, 100);
    maxforce = maxspeed;//random(0.2, 1);
    acceleration = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(PVector.div(force, mass));
  }

  void applyBehaviors(PointMesh[][] pointsMesh) {
    PVector separateForce = separate(pointsMesh);
     PVector seekForce;
    if(etat)
    {
     seekForce = seek(new PVector(0,0,0));
    }
    else
    {
      seekForce = seek(origine);
    }
    separateForce.mult(0);
    seekForce.mult(0.1);
    applyForce(separateForce);
    applyForce(seekForce);
  }

  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    
    
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force

      return steer;
  }

  void arrive(PVector target) {
    PVector desired = PVector.sub(target,location);  // A vector pointing from the location to the target
    float d = desired.mag();
    // Scale with arbitrary damping within 100 pixels
    if (d < 100) {
      float m = map(d,0,100,0,maxspeed);
      desired.setMag(m);
    } else {
      desired.setMag(maxspeed);
    }

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    applyForce(steer);
  }
  
  //calculate new coordinate
  PVector newTarget(float mag)
  {
    PVector desired = location.get();  // A vector pointing from the location to the target
    
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(mag);
    
    return desired;
  }
    

  // Separation
  // Method checks for nearby vehicles and steers away
  PVector separate (PointMesh[][] pointsMesh) {
    float desiredseparation = r*2;
    PVector sum = new PVector();
    int count = 0;
    // For every boid in the system, check if it's too close
    for (int i = 0; i<cols; i++)
    {
      for (int j= 0; j<rows; j++)
      { 
        PointMesh other = pointsMesh[i][j];
        float d = PVector.dist(location, other.location);
        // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
        if ((d > 0) && (d < desiredseparation)) {
          // Calculate vector pointing away from neighbor
          PVector diff = PVector.sub(location, other.location);
          diff.normalize();
          diff.div(d);        // Weight by distance
          sum.add(diff);
          count++;            // Keep track of how many
        }
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      sum.div(count);
      // Our desired vector is the average scaled to maximum speed
      sum.normalize();
      sum.mult(maxspeed);
      // Implement Reynolds: Steering = Desired - Velocity
      sum.sub(velocity);
      sum.limit(maxforce);
    }
    return sum;
  }


  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void display() {
    pushStyle();
    strokeWeight(2);
    stroke(255, 0, 0);
    point(location.x, location.y, location.z);
    popStyle();
  }
}





