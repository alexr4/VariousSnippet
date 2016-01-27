import peasy.*;
PeasyCam cam;

int pWidth = 1920;
int pHeight = 1080;

int maxAngle;
int resAngle;
int gridWidth;
int gridDepth;
int resX;
int resD;
int cols, rows;
PVector[][] vertices;
float[][] radius;

float xInc, xOff, yInc, yOff, zInc, zOff;

boolean depth;
float alphaFill;

void setup()
{
  size(1280, 720, P3D);
  smooth(8);


  initParamMesh();
  initMesh();


  //Peasy
  cam = new PeasyCam(this, 500);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(2000);
}

void draw()
{
  background(255);
  axes(100);
  world(width);

  if (depth)
  {
    alphaFill = 127;
    noStroke();
    hint(ENABLE_DEPTH_SORT);
  } else
  {
    alphaFill = 255;
    stroke(255, 20);
    strokeWeight(1);
    hint(DISABLE_DEPTH_SORT);
  }

  //Spherical grid
  beginShape(QUAD);
  for (int i =0; i<cols-1; i++)
  {
    for (int j=0; j<rows-1; j++)
    {
      PVector v0 = vertices[i][j];
      PVector v1 = vertices[i][j+1];
      PVector v2 = vertices[i+1][j];
      PVector v3 = vertices[i+1][j+1];

      float r = radius[i][j];

      float r0 = map(v0.x, -r, r, 0, 255);
      float g0 = map(v0.y, -r, r, 0, 255);
      float b0 = map(v0.z, -r, r, 0, 255);

      float r1 = map(v1.x, -r, r, 0, 255);
      float g1 = map(v1.y, -r, r, 0, 255);
      float b1 = map(v1.z, -r, r, 0, 255);

      float r2 = map(v2.x, -r, r, 0, 255);
      float g2 = map(v2.y, -r, r, 0, 255);
      float b2 = map(v2.z, -r, r, 0, 255);

      float r3 = map(v3.x, -r, r, 0, 255);
      float g3 = map(v3.y, -r, r, 0, 255);
      float b3 = map(v3.z, -r, r, 0, 255);



      fill(r0, g0, b0, alphaFill);
      vertex(v0.x, v0.y, v0.z);
      fill(r1, g1, b1, alphaFill);
      vertex(v1.x, v1.y, v1.z);
      fill(r3, g3, b3, alphaFill);
      vertex(v3.x, v3.y, v3.z);
      fill(r2, g2, b2, alphaFill);
      vertex(v2.x, v2.y, v2.z);
    }
  }
  endShape(CLOSE);
}

void axes(int taille)
{
  pushStyle();
  stroke(255, 0, 0);
  line(0, 0, 0, taille, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, taille, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, taille);
  popStyle();
}

void world(int taille)
{
  pushStyle();
  stroke(127);
  noFill();
  box(taille);
  popStyle();
}

void initMesh()
{
  for (int i = 0; i<gridDepth/resD; i++)
  {
    float z = (pWidth/2)+(resD*i)*-1;

    float noiseY = map(noise(xInc), 0, 1, -50, 50);
    float noiseX = map(noise(zInc), 0, 1, -50, 50);

    float phiInc = map(i*10, 0, gridDepth/resD*10, 0, PI);

    for (int j = 0; j<maxAngle/resAngle; j++)
    {
      float phi = phiInc+map(j, 0, (maxAngle/resAngle)-1, 0, radians(maxAngle));

      float noise;
      float mapRadius = map(i, 0, gridDepth/resD-1, 100, 0);

      if (j == 0 || j == maxAngle/resAngle-1)
      {
        noise = map(noise(xInc, 0, zInc), 0, 1, 0, mapRadius*4);
      } else
      {
        noise = map(noise(xInc, yInc, zInc), 0, 1, 0, mapRadius*4);
      }


      radius[i][j] = mapRadius+noise;

      float x = cos(phi)*radius[i][j]+noiseX;
      float y = sin(phi)*radius[i][j]+noiseY;

      PVector loc = new PVector(x, y, z);

      vertices[i][j] = loc;

      yInc += yOff;
    }
    xInc += xOff;
    zInc += zOff;
  }
}

void initParamMesh()
{
  //defineGrid
  maxAngle = 360;//int(random(45, 360));
  resAngle = int(random(10, 70));//70;
  gridWidth = pWidth;
  gridDepth = pWidth;
  resX = 10;
  resD = int(random(30, 70));//70
  xOff = random(0.01, 0.9);
  yOff = random(0.01, 0.9);
  zOff = random(0.01, 0.9);


  rows = maxAngle/resAngle;
  cols = gridDepth/resD;

  vertices = new PVector[cols][rows];
  radius = new float[cols][rows];
}

void keyPressed()
{
  if (key == ' ')
  {
    initParamMesh();
    initMesh();
  }
  if (key == 's')
  {
    saveFrame("cylinderExperiments_####.jpg");
  }

  if (key == 'd')
  {
    depth = !depth;
  }
}