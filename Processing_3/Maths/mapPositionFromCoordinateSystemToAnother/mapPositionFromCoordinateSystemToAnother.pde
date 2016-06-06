PVector loc = new PVector();
PVector newLoc = new PVector();

float ratioStart = (float) 512 / (float) 424;
float ratioEnd = (float) 1920 / (float) 1080;
int startWidth = 512;
int startHeight = 424;
int endWidth = int(512 / ratioEnd);
int endHeight = 424;

PVector startLoc = new PVector(100, 100);
PVector endLoc = new PVector(0, 0);//startLoc.x + startWidth/2 - endWidth / 2
int newOriginX = int(startLoc.x + startWidth/2 - endWidth / 2);
int newOriginY = 0;//startLoc.y + startHeight/2 - endHeight / 2
void setup()
{
  size(1024, 768, P2D);
}

void draw()
{
  background(255);

  loc.x = startLoc.x + noise(frameCount * 0.01) * startWidth;
  loc.y = startLoc.y + noise(frameCount * 0.02) * startHeight;
  
  newLoc = getNewMappedLocation(loc.copy(), newOriginX, newOriginY);


  //zone 1
  noFill();
  stroke(0, 255, 0);
  rect(startLoc.x, startLoc.y, startWidth, startHeight);
  drawAxis(10, new PVector(startLoc.x + startWidth/2, startLoc.y + startHeight/2), "RVB");
  noStroke();
  fill(0, 255, 0);
  ellipse(loc.x, loc.y, 25, 25);

  //zone 2
  pushMatrix();
  translate(newOriginX, newOriginY);
  noFill();
  stroke(255, 0, 0);
  rect(endLoc.x, endLoc.y, endWidth, endHeight);  
  drawAxis(10, new PVector(endLoc.x + endWidth/2, endLoc.y + endHeight/2), "RVB");
  noStroke();
  fill(255, 0, 0);
  ellipse(newLoc.x, newLoc.y, 20, 20);

  popMatrix();
}

void drawAxis(float l, PVector loc, String colorMode)
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
  pushMatrix();
  translate(loc.x, loc.y);
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
  popMatrix();
  popStyle();
}