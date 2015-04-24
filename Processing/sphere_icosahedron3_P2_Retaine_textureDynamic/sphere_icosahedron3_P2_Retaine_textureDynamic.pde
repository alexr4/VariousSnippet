/*
 Textured Sphere by Amnon Owed (April 2013) Updated by Alexandre Rivaux | Bonjour, interactive lab (April 2014);
 ---------------------------                     --------------------------                     
 https://github.com/AmnonOwed                      http://www.bonjour-lab.com
 http://vimeo.com/amnon                            http://www.vimeo.com/bonjour
 
 Creating a textured sphere by subdividing an icosahedron.
 Using the PShape Object to store and display the shape (processing 2.x).
 
 The benefits of the current creation method are:
 1. Even distribution of vertices over the sphere
 2. No seam or pole problems in the texture coordinates
 3. Using GPU in order to store a large vertices array (more performances)
 
 MOUSE  = arcball around the sphere
 
 Built with Processing 1.5.1 + GLGraphics 1.0.0
 update with Processing 2.x
 */

import java.util.*; 

//set of texture
PImage tex;
PImage tex2;
PImage tex3;

//Volume Variables
PApplet parent;
Icosahedron ico;
int nbSubdivision;
boolean icoWire, icoNormals, icoVertices;


//Scene Variables
float zoom = 0;
PVector rotation = new PVector();
PVector velocity = new PVector();
float rotationSpeed = 0.02;

PVector acceleration= new PVector();
PVector orientation;
float sens, sens2;
float amplitude;

int nbCharacters;
float p1, p2, p3;
int f;


//light
ArrayList<PVector> lightPos;
ArrayList<Float> angleLight;
float r2= 500;
float inc = 0;

float rx, ry;

// --------------------------------------------------------

void setup() {
  size(1280, 720, P3D);
  smooth(8);
  parent = this;
  colorMode(HSB, 360, 100, 100, 100);
  
  tex = loadImage("textureMap.jpg");
  tex2 = loadImage("plop.JPG");
  tex3 = loadImage("world32k.jpg");
  
  lightPos = new ArrayList<PVector>();
  angleLight = new ArrayList<Float>();

  addLight();

  //println(lightPos.size());


  nbCharacters = 140;  
  f = round((sqrt((nbCharacters-2)/10.0)-1)); //Frequency of Icosahedron : f = sqrt((Vertices-2)/10)


  nbSubdivision = 7; //max 7
  ico = new Icosahedron(nbSubdivision, 200, tex3);
  

  amplitude = 0.1;

  icoNormals = false;
  icoWire = false;
  icoVertices = false;
  
  
}

void draw() {

  background(0);
  perspective();
  
  pushMatrix();
  translate(width/2, height/2, zoom);

  sceneControl();
  
  /*
  lightSpecular(190, 30, 60);
  drawLight(true, 10); 
  shininess(30.0);
  */
  
  showWorld(true);
 

  ico.displayFace();
  
  if (icoNormals)
  {
    ico.displayNormals(new PVector(0, 0, 0));
  }
  if (icoWire)
  {
    ico.displayWireframe();
  }
  if (icoVertices)
  {
    ico.showVertices(-rotation.y);
  }
  popMatrix();
 
}


void keyPressed() {
  if (key == '-')
  {
    zoom -= 10;
    println(zoom);
  }
  if (key == '+')
  {
    zoom += 10;
  }

 
  if (key == 'n')
  {
    icoNormals = !icoNormals;
  }
  if (key == 'w')
  {
    icoWire = !icoWire;
  }
  if (key == 'j')
  {
    icoVertices = !icoVertices;
  }
}

void sceneControl()
{
  rotateX(rotation.x);
  rotateY(rotation.y);

  if (mouseX <width/2-100)
  {
    sens = map(mouseX, 0, width/2-100, -1, 0);
  }
  else if (mouseX >+width/2+100)
  {
    sens = map(mouseX, width/2+100, width, 0, 1);
  }
  else
  {
    sens = 0;
  }

  if (mouseY <height/2-100)
  {
    sens2 = map(mouseY, 0, height/2-100, -1, 0);
  }
  else if (mouseY >+height/2+100)
  {
    sens2 = map(mouseY, height/2+100, height, 0, 1);
  }
  else
  {
    sens2 = 0;
  }

  orientation = new PVector(sens2*amplitude , sens*amplitude); //sens2*amplitude 

    acceleration.add(orientation);
  velocity.add(acceleration);
  rotation.add(velocity);
  acceleration.mult(0);
  velocity.mult(0);

  frame.setTitle(" " + int(frameRate));
}

void showWorld(boolean etat)
{
  if (etat)
  {
    stroke(0, 100, 100);
    line(0, 0, 0, 100, 0, 0);
    stroke(123, 100, 100);
    line(0, 0, 0, 0, 100, 0);
    stroke(219, 100, 100);
    line(0, 0, 0, 0, 0, 100);
  }
}


void addLight()
{
  float iMax = 4;

  for (int i=0; i<iMax; i++)
  {

    float angle = map(i, 0, iMax, 0, TWO_PI);

    float x0 = r2*cos(angle);
    float y0 = r2*sin(angle);
    float z0 = -inc;
    PVector pos0 = new PVector(x0, y0, z0);

    float x1 = r2*cos(angle);
    float y1 = 0;
    float z1 = r2*sin(angle)-inc;
    PVector pos1 = new PVector(x1, y1, z1);

    lightPos.add(pos0);
    lightPos.add(pos1);

    angleLight.add(angle);
    angleLight.add(angle);

    //println(angleLight);
  }
}

void drawLight(boolean etat, float t)
{
  for (int i=0; i<lightPos.size(); i++)
  {
    PVector v = lightPos.get(i);
    float angle = angleLight.get(i);

    float h = map(angle, 0, TWO_PI, 180, 260);
    float s = 0;
    float b = 100;//map(v.z, -r2-inc, r2-inc, 50, 100);
    if (etat)
    {
      pushStyle();
      stroke(h, s, b);
      strokeWeight(t);
      point(v.x, v.y, v.z);
      popStyle();
    }
    else
    {
    }
    pointLight(h, s, b, v.x, v.y, v.z);
  }
}

