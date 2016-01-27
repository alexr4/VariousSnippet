import peasy.*;

PeasyCam cam;

PVector camPosition;
float distance00;
float distance01;
float angle;

void setup()
{
  size(500, 500, P3D);
  cam = new PeasyCam(this, 250);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);

  camPosition = new PVector(0, 0, 1);
  camPosition.mult(100);
}

void draw()
{
  background(127);

  stroke(0, 255, 255);
  strokeWeight(5);
  point(camPosition.x, camPosition.y, camPosition.z); 
  strokeWeight(1);
  line(0, 0, 0, camPosition.x, camPosition.y, camPosition.z);

  //LightAxis
  distance00 = 100;
  distance01 = 100;
  PVector axisKey = compute3DRotationVector(camPosition.get(), radians(60), 'y'); 
   PVector axisFill = compute3DRotationVector(camPosition.get(), radians(-30), 'y');
  PVector dak =axisKey.get();
  PVector daf = axisFill.get();
  dak.mult(distance00);
  daf.mult(distance01);
  
  //debugLine
  
  stroke(255, 0, 255);
  line(0, 0, 0, dak.x, dak.y, dak.z);
  stroke(255, 255, 0);
  line(0, 0, 0, daf.x, daf.y, daf.z);

  //LightPOsition computation
  PVector keyLight = computeRodrigueRotation(axisFill.get(), axisKey.get(), radians(-30));
  PVector fillLight = computeRodrigueRotation(axisKey.get(), axisFill.get(), radians(-30));
  keyLight.mult(distance00);
  fillLight.mult(distance01);
  stroke(255, 0, 255);
  line(0, 0, 0, keyLight.x, keyLight.y, keyLight.z);
  stroke(255, 255, 0);
  line(0, 0, 0, fillLight.x, fillLight.y, fillLight.z);
  
  fill(0);
  noStroke();
  text("Key light", keyLight.x, keyLight.y, keyLight.z);
  text("Fill light", fillLight.x, fillLight.y, fillLight.z);

  angle = map(mouseX, 0, width, 0, TWO_PI);

  drawAxis(20, "RVB");
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