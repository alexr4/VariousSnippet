int pWidth = 500;
int pHeight = 500;

float radiusA, radiusB;
float thetaOffset;
PVector origin;

void setup()
{
  size(pWidth, pHeight, P3D);
  smooth(8);
  initVariables();
}

void draw()
{
  background(255);

  strokeWeight(2);
  stroke(0);
  for (int i=0; i<=360; i+=thetaOffset)
  {
    float theta = radians(i);



    float x = origin.x + cos(theta) * radiusA;
    float y =origin.y + sin(theta)*radiusB;//origin.y + sin(theta) * radiusB;
    float z = origin.z;

    point(x, y, z);
  }
}

public void initVariables()
{
  radiusA = random(100, 200);
  radiusB = random(100, 200);
  origin = new PVector(width/2, height/2, 0);
  thetaOffset = random(5, 10);
}

void mousePressed()
{
  initVariables();
}

