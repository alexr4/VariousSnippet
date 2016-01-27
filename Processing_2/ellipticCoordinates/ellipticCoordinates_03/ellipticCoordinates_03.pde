import peasy.*;
PeasyCam cam;

int pWidth = 500;
int pHeight = 500;

float radiusX, radiusY, radiusZ;
int thetaOffset;
int hueInc;
int cols, rows;
PVector[][] verticesList;
ArrayList<Integer> hueList;


void setup()
{
  size(pWidth, pHeight, P3D);
  smooth(8);
  // colorMode(HSB, 360, 100, 100, 100);


  cam = new PeasyCam(this, 0, 0, 0, 500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(2000);

  initVariables();
}

void draw()
{
  background(255);


  readEllipsoid();

  drawAxis(50);
}

public void initVariables()
{
  radiusX = random(100, 150);
  radiusY = random(100, 150);
  radiusZ = random(100, 150);

  thetaOffset = round(random(50, 100));
  cols = thetaOffset;
  rows = thetaOffset;
  hueInc = 0;

  verticesList = new PVector[cols][rows];

  hueList = new ArrayList<Integer>();
  ;

  createEllipsoid();
}

public void createEllipsoid()
{

  for (int i = 0; i<cols; i++)
  {

    for (int j = 0; j<rows; j++)
    { 

      float alpha = map(i, 0, cols-1, 0, PI);
      float beta = map(j, 0, rows-1, 0, TWO_PI);

      float x =  sin(alpha)*cos(beta)*radiusX;
      float y =  sin(alpha)*sin(beta)*radiusY;
      float z =  cos(alpha)*radiusZ;


      if (((1+i)*(j+1))%4 == 0)
      {
        hueInc ++;
      }

      verticesList[i][j] = new PVector(x, y, z);
      hueList.add(hueInc);
    }
  }
}

public void readEllipsoid()
{
  beginShape(QUAD_STRIP);
  for (int i =0; i<cols-1; i++)
  {
    for (int j=0; j<rows-1; j++)
    {
      PVector v0 = verticesList[i][j];
      PVector v1 = verticesList[i][j+1];
      PVector v2 = verticesList[i+1][j];
      PVector v3 = verticesList[i+1][j+1];
      float alphaS = 25;
      float alphaF = 100;

      PVector normv0 = v0.get();
      PVector normv1 = v1.get();
      PVector normv2 = v2.get();
      PVector normv3 = v3.get();

      normv0.normalize();
      normv1.normalize();
      normv2.normalize();
      normv3.normalize();


      strokeWeight(1);
      stroke(255, alphaS);
      
      fill(normv0.x*255, normv0.y*255, normv0.z*255);
      vertex(v0.x, v0.y, v0.z);

      fill(normv1.x*255, normv1.y*255, normv1.z*255);
      vertex(v1.x, v1.y, v1.z);

      fill(normv2.x*255, normv2.y*255, normv2.z*255);
      vertex(v2.x, v2.y, v2.z);

      fill(normv3.x*255, normv3.y*255, normv3.z*255);
      vertex(v3.x, v3.y, v3.z);
    }
  }

  endShape(CLOSE);
}

void keyPressed()
{
  initVariables();
}

void drawAxis(float l)
{
  pushStyle();
  strokeWeight(3);
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

