import peasy.*;

PeasyCam cam;

PVector begin, end;

void setup()
{
  size(500, 500, P3D);
  smooth(8);
  cam = new PeasyCam(this, 500);

  begin = new PVector(random(-width/2, width/2), random(-height/2, height/2), random(-100, 100));
  end = new PVector(random(-width/2, width/2), random(-height/2, height/2), random(-100, 100));


  cam = new PeasyCam(this, begin.x, begin.y, begin.z, 500);
}

void draw()
{
  background(40);
  drawAxis(100, "RVB");
  showPoint(begin, 255, 0, 0);
  showPoint(end, 0, 0, 255);

  stroke(0, 255, 0);
  line(begin.x, begin.y, begin.z, end.x, end.y, end.z);
  
  PVector v0tov1 = PVector.sub(end, begin);
  PVector n = v0tov1.normalize();
  n.mult(50);
  stroke(255, 255, 0);
  line(0, 0, 0, n.x, n.y, n.z);

  //compute angle between two vectors
  PVector v0 = new PVector(0, 1, 0);
  PVector v1 = v0tov1.copy().normalize();

  float v0Dotv1 = PVector.dot(v0, v1);
  float phi = acos(v0Dotv1);
  PVector axis = v0.cross(v1);
  println(degrees(phi), axis);

  pushMatrix();
  drawAxis(50, begin, phi, axis, 127, 127, 127);
  popMatrix();
}

void keyPressed()
{
  if (key == 'u' || key == 'U')
  {
    begin = new PVector(random(-width/2, width/2), random(-height/2, height/2), random(-100, 100));
    end = new PVector(random(-width/2, width/2), random(-height/2, height/2), random(-100, 100));
    cam = new PeasyCam(this, begin.x, begin.y, begin.z, 500);
  }
}

void showPoint(PVector loc, float r, float g, float b)
{
  pushStyle();
  strokeWeight(10);
  stroke(r, g, b);
  point(loc.x, loc.y, loc.z);
  popStyle();
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
void drawAxis(float l, PVector loc, float r, float g, float b)
{
  color xAxis = color(r, g, b);
  color yAxis = color(r, g, b);
  color zAxis = color(r, g, b);


  pushMatrix();
  translate(loc.x, loc.y, loc.z);
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
  popMatrix();
}

void drawAxis(float l, PVector loc, float phi, PVector axis, float r, float g, float b)
{
  color xAxis = color(r, 0, 0);
  color yAxis = color(0, g, 0);
  color zAxis = color(0, 0, b);


  pushMatrix();
  translate(loc.x, loc.y, loc.z);
  rotate(phi, axis.x, axis.y, axis.z);
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
  popMatrix();
}