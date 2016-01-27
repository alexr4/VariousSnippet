
import peasy.*;
PeasyCam cam;

int samples;
float a1, a2, a3;
float u1, u2, v1, v2;
float dU;
float dV;
float n, e;

int cols, rows;
PVector[][] vertice;

void setup() {
  size(500, 500, P3D); //setup the screen


  cam = new PeasyCam(this, width/2, height/2, 0, 1500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(2000);
  initMesh();
}

void draw()
{
  background(255);
  translate(width/2, height/2);
  readVerticeArray();
}

float sign ( float x ) {
  if ( x < 0 )return -1;
  if ( x > 0 )return 1;
  return 0;
}
float sqSin( float v, float n ) {
  return sign(sin(v)) * pow(abs(sin(v)), n);
}
float sqCos( float v, float n ) {
  return sign(cos(v)) * pow(abs(cos(v)), n);
}

void initMesh()
{
  /*sample*/
  /*
  samples = 20;
  a1 = 100.;
  a2 = 100.;
  a3 = 100.;
  u1 = 0.;
  u2 = 20.;
  v1 = 0.;
  v2 = 20.;
  dU = (u2 - u1) / samples;
  dV = (v2 - v1) / samples;
  n = 1.;
  e = 1.;
  */
  
  samples = 50;
  a1 = 100;
  a2 = 100;
  a3 = 100;
  u1 = 0;
  u2 = 20;
  v1 = 0;
  v2 = 20;
  dU = (u2 - u1) / samples;
  dV = (v2 - v1) / samples;
  n = random(-5, 5);
  e = random(-5, 5);

  cols = samples;
  rows = samples;


  vertice = new PVector[cols][rows];

  float u = u1;
  for (int i=0; i<samples; i++) {
    float v = v1;
    for (int j=0; j<samples; j++) {
      float x = a1 * sqCos (u, n) * sqCos (v, e);
      float y = a2 * sqCos (u, n) * sqSin (v, e);
      float z = a3 * sqSin (u, n);
      vertice[i][j] = new PVector(x, y, z);
      v += dV;
    }
    u += dU;
  }
}

void readVerticeArray()
{

  beginShape(QUAD);
  for (int i =0; i<cols-1; i++)
  {
    for (int j=0; j<rows-1; j++)
    {
      
      PVector v0 = vertice[i][j];
      PVector v1 = vertice[i+1][j];
      PVector v2 = vertice[i][j+1];
      PVector v3 = vertice[i+1][j+1];

      float r0 = map(v0.x, -a1, a1, 0, 255);
      float g0 = map(v0.y, -a2, a2, 0, 255);
      float b0 = map(v0.z, -a3, a3, 0, 255);

      float r1 = map(v1.x, -a1, a1, 0, 255);
      float g1 = map(v1.y, -a2, a2, 0, 255);
      float b1 = map(v1.z, -a3, a3, 0, 255);

      float r2 = map(v2.x, -a1, a1, 0, 255);
      float g2 = map(v2.y, -a2, a2, 0, 255);
      float b2 = map(v2.z, -a3, a3, 0, 255);

      float r3 = map(v3.x, -a1, a1, 0, 255);
      float g3 = map(v3.y, -a2, a2, 0, 255);
      float b3 = map(v3.z, -a3, a3, 0, 255);

      float alpha = 255;


      stroke(255, 50);
      strokeWeight(1);
      //noStroke();

      //Face
     fill(r0, g0, b0, alpha);
      vertex(v0.x, v0.y, v0.z);
     fill(r1, g1, b1, alpha);
      vertex(v1.x, v1.y, v1.z);
      fill(r3, g3, b3, alpha);
      vertex(v3.x, v3.y, v3.z);
      fill(r2, g2, b2, alpha);
      vertex(v2.x, v2.y, v2.z);

     
    }
  }

  endShape(CLOSE);
}

void keyPressed()
{
  if(key == ' ')
  {
    initMesh();
  }
}

