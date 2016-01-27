import peasy.*;
PeasyCam cam;

int pWidth = 500;
int pHeight = 500;

float radiusX, radiusY, radiusZ;
float thetaOffset;
PVector origin;

void setup()
{
  size(500, 500, P3D);
  smooth(8);


  cam = new PeasyCam(this, width/2, height/2, 0, 500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(2000);

  initVariables();
}

void draw()
{
  background(255);
  
  
  strokeWeight(2);
  stroke(0);
  
  for (int i = 0; i<180; i+=thetaOffset)
  {

    for (int j = 0; j<360; j+=thetaOffset)
    { 
      
      float alpha = radians(i);
      float beta = radians(j);

      float x =  origin.x + sin(alpha)*cos(beta)*radiusX;
      float y =  origin.y + sin(alpha)*sin(beta)*radiusY;
      float z =  origin.z + cos(alpha)*radiusZ;

      point(x, y, z);
    }
  }
  
  point(origin.x, origin.y, origin.z);
}

public void initVariables()
{
  radiusX = random(100, 150);
  radiusY = random(100, 150);
  radiusZ = random(100, 150);

  origin = new PVector(width/2, height/2, 0);
  thetaOffset = random(5, 10);
}

void keyPressed()
{
  initVariables();
}