PVector randomVec;
PVector secVector;
float angle;
float speedAngle;

import peasy.*;

PeasyCam cam;

void setup()
{
  size(500, 500, P3D);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);

  randomVec = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
  randomVec.mult(20);
  
  secVector = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
  secVector.mult(20);
}

void draw()
{
  background(255);
  
  stroke(255, 0, 255);
  strokeWeight(5);
  point(0, 0, 0);
  strokeWeight(1);
  line(0, 0, 0, randomVec.x, randomVec.y, randomVec.z);
  
  PVector rodrigueVector = computeRodrigueRotation(randomVec, secVector, angle);
  rodrigueVector.normalize();
  rodrigueVector.mult(20);
  stroke(0, 255, 255);
  strokeWeight(5);
  point(0, 0, 0);
  strokeWeight(1);
  line(0, 0, 0, rodrigueVector.x, rodrigueVector.y, rodrigueVector.z);
  
  drawAxis(10, "RVB");
  
  angle += 0.01;
}

void drawAxis(float l, String colorMode)
{
  color xAxis = color(255, 0, 0);
  color yAxis = color(0, 255, 0);
  color zAxis = color(0, 0, 255);

  if (colorMode == "rvb" || colorMode == "RVB")
  {
    xAxis = color(255, 0, 0);
    yAxis = color(0, 255, 0);
    zAxis = color(0, 0, 255);
  } else if (colorMode == "hsb" || colorMode == "HSB")
  {
    xAxis = color(0, 100, 100);
    yAxis = color(115, 100, 100);
    zAxis = color(215, 100, 100);
  }

  pushStyle();
  strokeWeight(1);
  //x-axis
  stroke(xAxis); 
  line(0, 0, 0, l, 0, 0);
  //y-axis
  stroke(yAxis); 
  line(0, 0, 0, 0, l, 0);
  //z-axis
  stroke(zAxis); 
  line(0, 0, 0, 0, 0, l);
  popStyle();
}


