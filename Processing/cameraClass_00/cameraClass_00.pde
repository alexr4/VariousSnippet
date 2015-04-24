
class CameraObject
{
  //variables
  float fov;
  float aspectRatio;
  float zNear;
  float zFar;

  PVector loc, aim;
  float radius;
  float upX, upY, upZ;

  float deltaX; //distance between the x (aim and eye);
  float deltaY; //distance between the y (aim and eye);
  float deltaZ; //distance between the z (aim and eye);
  float magDelta;
  float azimuth, elevation, rolls; //angle for roll, pitch yaw

  float elevationLimit;
  float azimuthLimit;
  float origineElevation;
  float origineAzimuth;
  float azimuthPrime, rangeAzimuth, speedRangeAzimuth;
  boolean beginAzimuthLerp;
  float elevationPrime, rangeElevation, speedRangeElevation;
  boolean beginElevationLerp;


  //constructeur
  CameraObject(PVector loc_, PVector aim_)
  {

    loc = loc_;
    aim = aim_;
    radius = loc.z;


    upX = 0;
    upY = 1;
    upZ = 0;

    deltaX = loc.x-aim.x;
    deltaY = loc.y-aim.y;
    deltaZ = loc.z-aim.z;

    PVector d = new PVector(deltaX, deltaY, deltaZ);
    magDelta = d.mag();
    /*
    azimuth = atan2(deltaX, deltaZ);
     elevation = atan2(deltaY, sqrt(deltaZ*deltaZ+deltaX*deltaX));
     */

    initPerspective();
    initLimit();
    initAnimationParameters();
  }
  //méthodes
  void initLimit()
  {
    println("\tinit limit angles");
    setElevationLimit(90);
    setAzimuthLimit(10);
    setAzimuth(PI+HALF_PI);
    setElevation(0); 
    updateCam();
  }

  void initAnimationParameters()
  {
    origineAzimuth = getAzimuth();
    azimuthPrime = getAzimuth();
    rangeAzimuth = 0;
    setSpeedRangeAzimuth(0.5);


    origineElevation = getElevation();
    azimuthPrime = getElevation();
    rangeElevation = 0;
    setSpeedRangeElevation(0.5);
  }

  void initPerspective()
  {
    println("\tinit perspective");
    setFov(70);//PI/3.0;
    setAspectRatio(1920.0, 1080.0);
    setNearFarClip(10.0, 10.0);
  }

  void resetCamera()
  {

    initLimit();
    initAnimationParameters();
  }


  void updateCam()
  {
    loc.x = aim.x+(magDelta*sin(HALF_PI+elevation)*sin(azimuth));
    loc.y = aim.y+(magDelta*cos(HALF_PI+elevation));
    loc.z = aim.z+(magDelta*sin(HALF_PI+elevation)*cos(azimuth));

    updateUp();
  }

  void updateAim()
  {
    aim.x = loc.x-(magDelta*sin(HALF_PI+elevation)*sin(azimuth));
    aim.y = loc.y-(-magDelta*cos(HALF_PI+elevation));
    aim.z = loc.z-(magDelta*sin(HALF_PI+elevation)*cos(azimuth));

    updateUp();
  }

  void updateUp()
  {
    //new Delta
    deltaX = loc.x-aim.x;
    deltaY = loc.y-aim.y;
    deltaZ = loc.z-aim.z;

    // Calculate the new "up" vector for the camera
    upX = -deltaX * deltaY;
    upY =  deltaZ * deltaZ + deltaX * deltaX;
    upZ = -deltaZ * deltaY;

    // Normalize the "up" vector
    PVector deltaVec = new PVector(deltaX, deltaY, deltaZ);
    float mag = deltaVec.mag();

    upX /= mag;
    upY /= mag;
    upZ /= mag;


    // Calculate the roll if there is one
    if (rolls != 0)
    {
      // Calculate the camera's X axis in world space
      float directionX = deltaY * upZ - deltaZ * upY;
      float directionY = deltaX * upZ - deltaZ * upX;
      float directionZ = deltaX * upY - deltaY * upX;

      // Normalize this vector so that it can be scaled
      PVector d = new PVector(directionX, directionY, directionZ);
      float m = d.mag();

      directionX /= m;
      directionY /= m;
      directionZ /= m;

      // Perform the roll
      upX = upX * cos(rolls) + directionX * sin(rolls);
      upY = upY * cos(rolls) + directionY * sin(rolls);
      upZ = upZ * cos(rolls) + directionZ * sin(rolls);
    }
  }



  void goToOrigine()
  {
    goToAzimuth();
    goToElevation();
  }

  void goToOrigine(float speedYaw, float speedPitch)
  {
    setSpeedRangeAzimuth(speedYaw);
    setSpeedRangeElevation(speedPitch);

    goToAzimuth();
    goToElevation();
  }

  void goToOrigine(float speed)
  {
    setSpeedRangeAzimuth(speed);
    setSpeedRangeElevation(speed);
    
    goToAzimuth();
    goToElevation();
  }


  void goToAzimuth()
  {
    if (getAzimuth() != origineAzimuth)
    {
      if (!beginAzimuthLerp)
      {
        azimuthPrime = getAzimuth();
        rangeAzimuth = 0;
        beginAzimuthLerp = true;
      }
      else
      {
        azimuth = lerp(azimuthPrime, origineAzimuth, rangeAzimuth);
        updateCam();
        updateRangeAzimuth();
      }
    }
  }

  void goToElevation()
  {
    if (getElevation() != origineElevation)
    {
      if (!beginElevationLerp)
      {
        elevationPrime = getElevation();
        rangeElevation = 0;
        beginElevationLerp = true;
      }
      else
      {
        elevation = lerp(elevationPrime, origineElevation, rangeElevation);
        updateCam();
        updateRangeElevation();
      }
    }
  }

  void updateRangeAzimuth()
  {
    if (rangeAzimuth < 1)
    {
      rangeAzimuth += speedRangeAzimuth;
    }
    else
    {
      rangeAzimuth = 1;
    }
  }

  void updateRangeElevation()
  {
    if (rangeElevation < 1)
    {
      rangeElevation += speedRangeElevation;
    }
    else
    {
      rangeElevation = 1;
    }
  }

  void debug()
  {
    pushStyle();

    pushMatrix();
    translate(aim.x, aim.y, aim.z);

    stroke(255, 0, 0);
    fill(255, 0, 0);
    sphere(40);
    popMatrix();

    pushMatrix();
    translate(loc.x, loc.y, loc.z);
    stroke(0, 0, 255);
    fill(0, 0, 255);
    box(40);

    popMatrix();

    stroke(255);
    line(loc.x, loc.y, loc.z, aim.x, aim.y, aim.z);
    popStyle();
  }




  //methode set
  void setAzimuth(float azimuth_)
  {
    azimuth = azimuth_;
  }

  void setElevation(float elevation_)
  {
    elevation = elevation_;
  }

  void setRoll(float rolls_)
  {
    rolls = rolls_;
  }

  void limitYaw(int state) //0 == pause, 1 == forward, 2 == backward
  {

    if (state == 1)
    {
      if (degrees(azimuth) < 180+azimuthLimit)
      {
        azimuth = radians(180+azimuthLimit);
      }
      else if (degrees(azimuth) > 360-azimuthLimit)
      {
        azimuth = radians(360-azimuthLimit);
      }
    }
    if (state == 2)
    {
      if (degrees(azimuth) < 0+azimuthLimit)
      {
        azimuth = radians(0+azimuthLimit);
      }
      else if (degrees(azimuth) > 180-azimuthLimit)
      {
        azimuth = radians(180-azimuthLimit);
      }
    }
    else if (state == 0);
    {
      azimuth = constrain(azimuth, 0, TWO_PI);
    }
  }

  void tiltEvent(float tiltOffset)
  {
    elevation = constrain(elevation-tiltOffset, 0-HALF_PI+0.0001, HALF_PI-radians(elevationLimit));

    updateCam();
  }

  void panEvent(float panOffset)
  {
    azimuth = (azimuth-panOffset+TWO_PI)%TWO_PI; //twopi

    updateCam();
  }

  void rollEvent(float rollOffset)
  {
    rolls = (rolls+rollOffset+TWO_PI)%TWO_PI;

    updateUp();
  }

  void setElevationLimit(float elevationLimit_)
  {
    elevationLimit = elevationLimit_;
  }

  void setAzimuthLimit(float azimuthLimit_)
  {
    azimuthLimit = azimuthLimit_;
  }

  void setFov(float angle_)
  {
    fov = radians(angle_);
  }

  void setAspectRatio(float width_, float height_)
  {
    aspectRatio = width_/height_;
  }

  void setNearFarClip(float near_, float far_)
  {
    zNear = loc.z/near_;
    zFar = loc.z*far_;
  }

  void setSpeedRangeAzimuth(float speedRangeAzimuth_)
  {
    speedRangeAzimuth = speedRangeAzimuth_*0.01;
  }

  void setSpeedRangeElevation(float speedRangeElevation_)
  {
    speedRangeElevation = speedRangeElevation_*0.01;
  }

  //methodes get
  float getAzimuth() //pan angle
  {
    return azimuth;
  }

  float getRoll() //rollAngle
  {
    return rolls;
  }

  float getElevation() //yaw angle
  {
    return elevation;
  }

  PVector getAim()
  {
    return aim;
  }

  PVector getLocation()
  {
    return loc;
  }

  void displayCamera(PGraphics os_)
  {
    os_.perspective(fov, aspectRatio, zNear, zFar);
    os_.camera(loc.x, loc.y, loc.z, aim.x, aim.y, aim.z, upX, upY, upZ);
  }

  void displayCamera()
  {
    perspective(fov, aspectRatio, zNear, zFar);
    camera(loc.x, loc.y, loc.z, aim.x, aim.y, aim.z, upX, upY, upZ);
  }
}

