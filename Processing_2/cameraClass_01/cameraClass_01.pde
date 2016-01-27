//finalize camera objet with change lookAt, change eye.x, eye.z, eye.y...
/*use Arrive methode ArriveAtLook and arriveAtEye*/

class CameraObject
{
  //variables
  //perspective varibales(fovy, aspect, zNear, zFar)
  float fovy, aspectRatio, nearField, farField;

  //camera variables
  PVector eye; //xyz-coordinate for the eye
  PVector center; //xyz-coordinate for the center of the scene
  PVector up; //usually 0.0, 1.0, or -1.0
  PVector origine;
  PVector oCenter;
  PVector target;
  PVector velocity;
  PVector acceleration;
  float maxForce;    // Maximum steering force
  float maxSpeed;    // Maximum speed

    //behaviors
  float vAlpha, vTheta;
  float alpha, theta;
  float radius;
  boolean alphaSens;

  float vx, vy, vz;
  float invertVx, invertVy, invertVz;
  float positiveVx, positiveVy, positiveVz;

  int behaviorNumber;
  boolean changeParticle;
  int index, indexParticle;
  PVector particleLocation, particlePastLocation;

  //ParticleSystem
  ArrayList<Particule> BirdsSystem;

  Timer timerCam;
  int randomTemps;

  PGraphics os;

  //constructeur
  CameraObject(float fov_, float sWidth_, float sHeight_, PVector eye_, PVector center_, ArrayList<Particule> particleSystem_, PGraphics os_) 
  {
    os = os_;
    //perspective
    fovy = fov_;
    aspectRatio = sWidth_/sHeight_;
    nearField = 10.0;
    farField = -1000.0;
    //camera
    eye = eye_.get();
    origine = eye.get();
    center = center_.get();
    oCenter = center;
    up = new PVector (0.0, 1.0, 0.0);
    velocity = new PVector(0, 0, 0);
    acceleration = new PVector(0, 0, 0);
    target = new PVector();
    behaviorNumber = 0;

    maxSpeed = 10;//random(1, 3);
    maxForce = random(0.1, 2);

    //behavior
    vAlpha = 0.1;//random(0.1, 0.5);
    vTheta = 1;//random(0.5, 1);
    radius = eye.z;

    vy = random(1, 2);
    vx = random(1, 2);
    vz = random(1, 2);

    invertVx = vx*-1;
    invertVy = vy*-1;
    invertVz = vz*-1;

    positiveVx = vx;
    positiveVy = vy;
    positiveVz = vz;

    alphaSens = false;

    BirdsSystem = particleSystem_;
    particleLocation = new PVector(0, 0, 0);
    particlePastLocation = new PVector(0, 0, 0);

    initTimer();
  }


  //methode
  void run()
  {
    cameraBehavior();
    camChange();
    perspectiveRun();
    cameraRun();
  }

  void cameraBehavior()
  {
    switch(behaviorNumber)
    {
    case 0:
      center = oCenter;
      //vAlpha = 0.05;//random(0.1, 0.5);
      rotateZCamera();
      break;
    case 1:  
      center = oCenter;
      vAlpha = 0.1;//random(0.1, 0.5);
      rotateYCamera();
      break;
    case 2:
      center = oCenter;
      //vAlpha = 0.05;//random(0.1, 0.5);
      spiralRotate();
      break;
    case 3:
      //println("case 3");
      followParticle();

      break;
    case 4:
      center = oCenter;
      //vAlpha = 5;//random(0.1, 0.5);
      origineCamera();
      break;
    case 5:
      //arrive(target);
      //updateEye();
      break;
    }

    // println(behaviorNumber);
  }

  void changeCameraBehavior()
  {
    behaviorNumber+=1;
    alpha = 0;
    origineCamera();

    if (behaviorNumber > 3)
    {
      behaviorNumber = 0;
    }
  }

  void setCameraBehavior(int numberCam)
  {
    behaviorNumber = numberCam;
  }

  void setIndexBird(int index)
  {
    changeParticle = false;
    indexParticle = index;
  }

  void followParticle()
  {

    if (changeParticle)
    {

      // println("followParticle 1");
      chooseParticle();
    } else
    {
      if (BirdsSystem.size() != 0) {
        Particule particule = BirdsSystem.get(indexParticle);
        //println("Nous avons choisi la particule");
        if (particule.vol == true ) {
          //println("nous suivons la particules");
          particleLocation = particule.position;
          particlePastLocation = particule.predictPrevioustLocation(270);
          eye = new PVector(particlePastLocation.x+50, particlePastLocation.y, particlePastLocation.z);
          center = particleLocation;

          // println("followParticle 2");
        } else if (particule.depart == true )
        {
          timerCam.stop(); 
          camChange();
        } else
        {
          chooseParticle();
        }
      }
    }
  }

  int chooseParticleSystem()
  {
    int randomPs = int(random(3));
    return randomPs;
  }

  void chooseParticle()
  {
    index = chooseParticleSystem();
    indexParticle = int(random(BirdsSystem.size()-1));
    changeParticle = false;
    //println("chooseParticle : "+indexParticle+" "+changeParticle);
  } 

  void perspectiveRun()
  {
    os.perspective(radians(fovy), aspectRatio, nearField, farField); // Field of view(angle de vue), ratio image, near field limit, far field limit
  }

  void cameraRun()
  {
    os.beginCamera();
    os.camera(eye.x, eye.y, eye.z, center.x, center.y, center.z, up.x, up.y, up.z);
    os.endCamera();
  }

  void rotateZCamera() 
  {
    // Rotates in "Height"
    eye.x = sin(radians(alpha))*radius+center.x;
    eye.y = eye.y;
    eye.z = cos(radians(alpha))*radius+center.z;

    checkAlpha(45);
    updateAlpha();
  }

  void rotateYCamera() 
  {
    // Rotates in "Height"
    eye.x = eye.x;
    eye.y = sin(radians(alpha))*radius+center.y;
    eye.z = cos(radians(alpha))*radius+center.z;

    checkAlpha(20);
    updateAlpha();
  }

  void updateAlpha()
  {
    if (alphaSens)
    {
      alpha += vAlpha;
    } else
    {
      alpha -= vAlpha;
    }
  }

  void checkAlpha(float limite)
  {
    if (abs(alpha) >= limite)
    {
      alphaSens = !alphaSens;
    }
  }

  void rotateXCamera() 
  {
    // Rotates in "Height"
    eye.x = sin(radians(alpha))*radius+center.x;
    eye.y = cos(radians(alpha))*radius+center.y;
    eye.z = eye.z;
    //checkAlpha(-90);
    //updateAlpha();
  }

  void spiralRotate()
  {

    eye.x = radius*sin(radians(alpha)) + center.x;
    eye.y = eye.y;
    eye.z = radius* cos (radians(alpha)) + center.z;

    if (eye.y> myWorld.heightWorld/2-100) 
    { 
      vy = invertVy;
    } else if (eye.y < -myWorld.heightWorld/2) 
    {
      vy = positiveVy;
    }

    eye.y += vy;
    checkAlpha(45);
    updateAlpha();
  }

  void origineCamera()
  {
    eye = origine.get();
  }

  void mouseControl()
  {
    eye.x = map(mouseX, 0, width, -width, width);
    eye.y = map(mouseY, 0, height, -height, height);   
    eye.z += vz;
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  void arrive(PVector target) {
    PVector desired = PVector.sub(target, eye);  // A vector pointing from the location to the target
    float d = desired.mag();
    // Scale with arbitrary damping within 100 pixels
    if (d < 100) {
      float m = map(d, 0, 100, 0, maxSpeed);
      desired.setMag(m);
    } else {
      desired.setMag(maxSpeed);
    }

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);  // Limit to maximum steering force
    applyForce(steer);
  }

  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, eye);  // A vector pointing from the location to the target

    // Normalize desired and scale to maximum speed
    desired.normalize();


    desired.mult(maxSpeed);


    // Steering = Desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);  // Limit to maximum steering force

      return steer;
  }

  void updateEye() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxSpeed);
    eye.add(velocity);

    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void updateLook() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxSpeed);
    center.add(velocity);

    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void initTimer()
  {
    randomTemps = int(random(15000, 20000));
    timerCam = new Timer(randomTemps);
    timerCam.start();
  }

  void camChange()
  {
    if (timerCam.isFinished()) {
      randomTemps = int(random(5000, 10000));
      vAlpha = random(0.1, 0.5);
      int numCam =int(random(4));

      if (numCam == 1) {
        alpha = 0;
      } else if (numCam == 3) {
        //println("dans le cas 3");
        changeParticle = true;
        randomTemps = int(random(2000, 4000));
      } else {
        alpha = random(-45, 45);
      }
      setCameraBehavior(numCam);

      timerCam.reset(randomTemps);
      timerCam.start();
    }
  }
}

