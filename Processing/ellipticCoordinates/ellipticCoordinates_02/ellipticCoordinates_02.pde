import peasy.*;
PeasyCam cam;

int pWidth = 500;
int pHeight = 500;

float radiusX, radiusY, radiusZ;
float thetaOffset;

ArrayList<PVector> verticesList;
ArrayList<Integer> hueList;  

void setup()
{
  size(pWidth, pHeight, P3D);
  smooth(8);
  colorMode(HSB, 360, 100, 100, 100);


  cam = new PeasyCam(this, 0, 0, 0, 500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(2000);

  initVariables();
}

void draw()
{
  background(0, 0, 100);


  strokeWeight(2);

  for (int i = 0; i<verticesList.size(); i++)
  {
    PVector v = verticesList.get(i);
    int hue = hueList.get(i);
    
    stroke(hue, 100, 100);
    point(v.x, v.y, v.z);
  }

  drawAxis(50);
}

public void initVariables()
{
  radiusX = random(100, 150);
  radiusY = random(100, 150);
  radiusZ = random(100, 150);

  thetaOffset = random(2, 5);

  verticesList = new ArrayList<PVector>();
  hueList = new ArrayList<Integer>();

  createEllipsoid();
}

public void createEllipsoid()
{
  for (int i = 0; i<180; i+=thetaOffset)
  {

    for (int j = 0; j<360; j+=thetaOffset)
    { 

      float alpha = radians(i);
      float beta = radians(j);

      float x =  sin(alpha)*cos(beta)*radiusX;
      float y =  sin(alpha)*sin(beta)*radiusY;
      float z =  cos(alpha)*radiusZ;

      int hue = round(map(i*j, 0, 360*180, 0, 360));

      PVector loc = new PVector(x, y, z);

      verticesList.add(loc);
      hueList.add(hue);
    }
  }
}

void keyPressed()
{
  initVariables();
}

void drawAxis(float l)
{
  pushStyle();
  strokeWeight(1);
  //x-axis
  stroke(0, 100, 100); 
  line(0, 0, 0, l, 0, 0);
  //y-axis
  stroke(120, 100, 100); 
  line(0, 0, 0, 0, l, 0);
  //z-axis
  stroke(230, 100, 100); 
  line(0, 0, 0, 0, 0, l);
  popStyle();
}

