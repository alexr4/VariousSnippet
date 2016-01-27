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
boolean icoWire, icoNormals, icoVertices, textScale;


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

//Offscreen
PGraphics offscreen;
PGraphics uvMap;
ArrayList<PVector> textCoord;
PShape textCoodShape;
float scale;

//globale
boolean isIcoCreated;

// --------------------------------------------------------

void setup() {
  size(1280, 720, P3D);
  smooth();
  parent = this;
  colorMode(HSB, 360, 100, 100, 100);

  offscreen = createGraphics(width, height, P3D);
  offscreen.smooth(8);

  uvMap = createGraphics(width, height, P3D);
  uvMap.smooth(8);
  textCoodShape = createShape(PShape.GROUP);

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



  amplitude = 0.1;

  icoNormals = false;
  icoWire = false;
  icoVertices = false;
  textScale = false;
  scale = 0.25;
}

void draw() {
  background(0);

  if (textScale)
  {
    scale = 1;
  }
  else
  {
    scale = 0.25;
  }

  if (isIcoCreated)
  {
    image(computeOffscreen(), 0, 0);
    image(computeUvMap(), 0, 0, width*scale, height*scale);
  }
  else
  {
    fill(0,0,100);
    textAlign(CENTER, CENTER);
    text("Waiting for shape to display - Press 'i' to create an icosahedron", width/2, height/2);
  }
}


void keyPressed() {
  if (key == '-')
  {
    zoom -= 10;
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
  if (key == 'a')
  {
    textScale = !textScale;
  }
  if (key == 'i')
  {
    if (!isIcoCreated)
    {
      initIco();
      isIcoCreated = true;
    }
  }
}

void initIco()
{
  println("creating icosahedron");
  ico = new Icosahedron(nbSubdivision, 200, tex3);
  textCoord = ico.getTextureCoorindatesArray();
  computeTextCoordShape();
  
  println("icosahedron has been created");
}

void sceneControl()
{
  offscreen.rotateX(rotation.x);
  offscreen.rotateY(rotation.y);

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

  orientation = new PVector(sens2*amplitude, sens*amplitude); //sens2*amplitude 

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
    offscreen.stroke(0, 100, 100);
    offscreen.line(0, 0, 0, 100, 0, 0);
    offscreen.stroke(123, 100, 100);
    offscreen.line(0, 0, 0, 0, 100, 0);
    offscreen.stroke(219, 100, 100);
    offscreen.line(0, 0, 0, 0, 0, 100);
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
      offscreen.pushStyle();
      offscreen.stroke(h, s, b);
      offscreen.strokeWeight(t);
      offscreen.point(v.x, v.y, v.z);
      offscreen.popStyle();
    }
    else
    {
    }
    offscreen.pointLight(h, s, b, v.x, v.y, v.z);
  }
}

PImage computeOffscreen()
{
  offscreen.beginDraw();
  offscreen.background(0);
  offscreen.perspective();

  offscreen.pushMatrix();
  offscreen.translate(width/2, height/2, zoom);

  sceneControl();

  /*
  lightSpecular(190, 30, 60);
   drawLight(true, 10); 
   shininess(30.0);
   */

  showWorld(true);


  offscreen.shape(ico.getIcoShape());

  if (icoNormals)
  {
    offscreen.shape(ico.getNormalShape());
  }
  if (icoWire)
  {
    offscreen.shape(ico.getWireframeShape());
  }
  if (icoVertices)
  {
    ico.showVertices(-rotation.y);
  }
  offscreen.popMatrix();
  offscreen.endDraw();

  return offscreen;
}

void computeTextCoordShape()
{
  for (int i=0; i<textCoord.size(); i+=3)
  {
    PShape face = createShape();
    PShape stroke = createShape();

    PVector loc0 = textCoord.get(i).get();
    PVector loc1 = textCoord.get(i+1).get();
    PVector loc2 = textCoord.get(i+2).get();

    loc0.x = map(loc0.x, 0, ico.textureWidth, 0, uvMap.width*0.85);
    loc0.y = map(loc0.y, 0, ico.textureHeight, 0, uvMap.height*0.85);
    loc1.x = map(loc1.x, 0, ico.textureWidth, 0, uvMap.width*0.85);
    loc1.y = map(loc1.y, 0, ico.textureHeight, 0, uvMap.height*0.85);
    loc2.x = map(loc2.x, 0, ico.textureWidth, 0, uvMap.width*0.85);
    loc2.y = map(loc2.y, 0, ico.textureHeight, 0, uvMap.height*0.85);

    face.beginShape();
    face.noFill();
    face.noStroke();
    face.texture(ico.tex);
    face.vertex(loc0.x, loc0.y, loc0.x, loc0.y);
    face.vertex(loc1.x, loc1.y, loc1.x, loc1.y);
    face.vertex(loc2.x, loc2.y, loc2.x, loc2.y);
    face.endShape();

    stroke.beginShape();
    stroke.noFill();
    stroke.stroke(165, 100, 100);
    stroke.vertex(loc0.x, loc0.y, loc0.x, loc0.y);
    stroke.vertex(loc1.x, loc1.y, loc1.x, loc1.y);
    stroke.vertex(loc2.x, loc2.y, loc2.x, loc2.y);
    stroke.endShape();

    textCoodShape.addChild(face);
    textCoodShape.addChild(stroke);
  }
}


PImage computeUvMap()
{
  uvMap.beginDraw();
  uvMap.background(255);


  uvMap.shape(textCoodShape);

  uvMap.endDraw();

  return uvMap;
}

