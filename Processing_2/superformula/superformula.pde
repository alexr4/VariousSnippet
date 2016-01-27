/* Mesh is not finish, the last points is not in the loop*/

import peasy.*;
PeasyCam cam;

int resAlpha;
int resBeta;
float r;
float alpha, beta, x, y, z;
int cols, rows;
PVector[][] vertice;
PointMesh[][] pointsMesh;

boolean etat;
float magTarget;
PVector targetPoint;
float noise1D, nInc, nOff;
// Superformula variables
int a, b;
float m, n1, n2, n3;
int scale_Factor;

void setup()
{
  size(600, 600, P3D);
  smooth();

  //colorMode(HSB, 360, 100, 100, 100);

  cam = new PeasyCam(this, width/2, height/2, 0, 50);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(2000);
 

  initSphere();
}

void draw()
{
  background(255);

  //lightsBehavior();
  translate(width/2, height/2);
  drawAxis(100);

  readVerticeArray();


  for (int i = 0; i<cols; i++)
  {
    for (int j= 0; j<rows; j++)
    { 
      PointMesh p = pointsMesh[i][j];
      // Path following and separation are worked on in this function
      //p.applyBehaviors(pointsMesh);

      if (etat)
      {
        p.arrive(p.target);
      }
      else
      {
        p.arrive(p.origine);
      }
      // Call the generic run method (update, borders, display, etc.)
      p.update();
      //p.display();
    }
  }


  //noiseTarget();
  frame.setTitle(" "+int(frameRate));
}

void initSphere()
{
  //creat array and variables
  resAlpha = int(random(1, 90));//13;
  resBeta = int(random(1, 90));//56;

  cols = 360/resAlpha;
  rows = 360/resBeta;

  nOff = random(0.001, 0.01);

//superformula
   a = int(random(1, 10));
   b = int(random(1, 10));
   m = random(1, 50);
   n1 = random(1, 50);
   n2 = random(1, 50);
   n3 = random(1, 50);
   scale_Factor = 200;


  vertice = new PVector[cols][rows];
  pointsMesh = new PointMesh[cols][rows];


  //init array
  for (int i = 0; i<cols; i++)
  {
    for (int j= 0; j<rows; j++)
    { 
      alpha = map(i, 0, cols-1, 0, PI);
      beta = map(j, 0, rows-1, 0, TWO_PI);
      PVector p = calculatePoint(alpha, beta);



      pointsMesh[i][j] = new PointMesh(p.x, p.y, p.z);
    }
  }
}

// Superformula implementation
// Parameters: a, b, m, n1, n2, n3 and angle
float superformula(float a, float b, float m, float n1, float n2, float n3, float angle) {
  float t1, t2;

  t1 = cos(m * angle / 4) / a;
  t1 = abs(t1);
  t1 = pow(t1, n2);

  t2 = sin(m * angle / 4) / b;
  t2 = abs(t2);
  t2 = pow(t2, n3);

  r = pow(t1+t2, 1/n1);

  return r;
}

// Calculate a single point in 3D
// Supply theta and phi
PVector calculatePoint(float theta, float phi) {
  // Acquire m, n1, n2, n3, a and b from controls

  // Run superformula for given values
  float r1 = superformula(a, b, m, n1, n2, n3, theta);
  float r2 = superformula(a, b, m, n1, n2, n3, phi);

  // Calculate coordinates
  float x = r1 * sin(theta) * r2 * cos(phi);
  float y = r1 * sin(theta) * r2 * sin(phi);
  float z = r2 * cos(theta);

  // Return the resulting vector
  return new PVector(x*scale_Factor, y*scale_Factor, z*scale_Factor);
}

void readVerticeArray()
{

  beginShape(TRIANGLES);
  for (int i =0; i<cols-1; i++)
  {
    for (int j=0; j<rows-1; j++)
    {
      PVector v0 = pointsMesh[i][j].location;
      PVector v1 = pointsMesh[i+1][j].location;
      PVector v2 = pointsMesh[i][j+1].location;
      PVector v3 = pointsMesh[i+1][j+1].location;

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

      float alpha = 255;


      stroke(255, 10);
      strokeWeight(1);

      //Face1
      fill(r0, g0, b0, alpha);
      vertex(v0.x, v0.y, v0.z);
      fill(r1, g1, b1, alpha);
      vertex(v1.x, v1.y, v1.z);
      fill(r2, g2, b2, alpha);
      vertex(v2.x, v2.y, v2.z);

      //Face2
      fill(r2, g2, b2, alpha);
      vertex(v2.x, v2.y, v2.z);
      fill(r1, g1, b1, alpha);
      vertex(v1.x, v1.y, v1.z);
      fill(r3, g3, b3, alpha);
      vertex(v3.x, v3.y, v3.z);
    }
  }

  endShape(CLOSE);
}

void drawAxis(float l)
{
  pushStyle();
  strokeWeight(1);
  //x-axis
  stroke(255, 0, 0); 
  line(0, 0, 0, l, 0, 0);
  //y-axis
  stroke(0, 255, 0); 
  line(0, 0, 0, 0, l, 0);
  //z-axis
  stroke(0, 0, 255); 
  line(0, 0, 0, 0, 0, l);
  popStyle();
}

void lightsBehavior()
{
  pointLight(0, 255, 160, 0, 0, 100);
  drawLight(0, 255, 160, 0, 0, 100, 10); 

  pointLight(0, 160, 255, 50*30, 50*30, 300);
  drawLight(0, 160, 255, 50*30, 50*30, 300, 10);

  pointLight(0, 0, 100, 50*15, 50*15, 500);
  drawLight(0, 0, 100, 50*15, 50*15, 500, 10);

  pointLight(0, 160, 255, width, 0, -1000);
  drawLight(0, 160, 255, width, height, -1000, 10);
}

void drawLight(int r, int v, int b, float x, float y, float z, int t)
{
  pushStyle();
  stroke(r, v, b);
  strokeWeight(t);
  point(x, y, z);
  popStyle();
}

void keyPressed()
{
  if (key == ' ')
  {

    initSphere();
  }

  if (key == 'a')
  {
    noiseTarget();
  }
}

void noiseTarget()
{
  /*float r= int(random(100));
   println(r);
   if (r < 10)
   {*/
  etat = !etat;
  noise1D = random(1);
  magTarget = map(noise1D, 0, 1, -1000, 1000);
  for (int i = 0; i<cols; i++)
  {
    for (int j= 0; j<rows; j++)
    { 
      PointMesh p = pointsMesh[i][j];
      // Path following and separation are worked on in this function
      //p.applyBehaviors(pointsMesh);

      p.target = p.newTarget(magTarget);
    }
  }

  nInc += nOff;
  //}
}

