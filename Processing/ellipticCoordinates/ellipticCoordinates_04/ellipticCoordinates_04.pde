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
  colorMode(HSB, 360, 100, 100, 100);


  cam = new PeasyCam(this, 0, 0, 0, 500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(2000);

  initVariables();
}

void draw()
{
  background(0, 0, 100);


  readEllipsoid();

  drawAxis(50);
}

public void initVariables()
{
  radiusX = random(100, 150);
  radiusY = random(100, 150);
  radiusZ = random(100, 150);

  thetaOffset = round(random(20, 50));
  cols = thetaOffset;
  rows = thetaOffset;
  hueInc = 0;

  verticesList = new PVector[cols][rows];

  hueList = new ArrayList<Integer>();;

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
      
      
      radiusX = 250 * sin(alpha) * sin(beta);
      radiusY = 250 * cos(alpha) * sin(beta);
      radiusZ = 250 * cos(alpha) * cos(beta);
      
      
      /*
      radiusX = 250 * sin(alpha * 2) * sin(beta * j);
      radiusY = 250 * cos(alpha * 2) * sin(beta * j);
      radiusZ = 250 * cos(alpha * 2) * cos(beta * j);
      */
      
      /*
      radiusX = 250 * cos(alpha * 10) * cos(beta);
      radiusY = 250 * cos(alpha * 10) * cos(beta);
      radiusZ = 250 * cos(alpha * 10) * cos(beta);
      */
      
      

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

      int hue = hueList.get(i*j);
      hue = round(map(hue, 0, hueInc, 0, 360));

      float alphaS = 25;
      float alphaF = 100;


      strokeWeight(1);
      stroke(0, 0, 100, alphaS);

      fill(hue, 100, 100, alphaF);
      vertex(v0.x, v0.y, v0.z);

      vertex(v1.x, v1.y, v1.z);

      vertex(v2.x, v2.y, v2.z);

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

