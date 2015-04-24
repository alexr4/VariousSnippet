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
 
 TO DO : Mix up Shader in order to create a TEXTLIGHT Shader (work only with TEXTShader
 */
import nervoussystem.obj.*;
import processing.dxf.*;

//set of texture
PImage[] textures;
int indexTex;
char[] keyIndex = {
  '1', '2', '3', '4', '5', '6'
};

//Volume Variables
Icosahedron ico;
int nbSubdivision;
boolean icoWire, icoNormals, showUV;


//3DScene Variables
float zoom = 0;
PVector rotation = new PVector();
PVector velocity = new PVector();
float rotationSpeed = 0.02;
PVector acceleration= new PVector();
PVector orientation;
float sens, sens2;
float amplitude;

//Frequence icosaèdre
int nbCharacters;
int f;

//light
ArrayList<PVector> lightPos;
ArrayList<Float> angleLight;
float r2= 500;
float inc = 0;
float rx, ry;

//Offscreen
PGraphics offscreen;

//globale
boolean isIcoCreated;
boolean recordDXF;
boolean recordOBJ;


// --------------------------------------------------------

void setup() {
  size(1280, 720, P3D);
  smooth();

  //bufferScreen
  offscreen = createGraphics(width, height, P3D);
  offscreen.smooth(8);

  //texture
  textures = new PImage[6];
  textures[0] = loadImage("earthmap1k.jpg");
  textures[1] = loadImage("earthspec1k.jpg");
  textures[2] = loadImage("earthbump1k.jpg");
  textures[3] = loadImage("earthlights1k.jpg");
  textures[4] = loadImage("earthcloudmap.jpg");
  textures[5] = loadImage("earthcloudmaptrans.jpg");

  //3DScene
  lightPos = new ArrayList<PVector>();
  angleLight = new ArrayList<Float>();
  addLight();

  //Frequence Icosaèdre
  nbCharacters = 140;  
  f = round((sqrt((nbCharacters-2)/10.0)-1)); //Frequency of Icosahedron : f = sqrt((Vertices-2)/10)

  //Boolean de controle + arcBall
  amplitude = 0.1;
  icoNormals = false;
  icoWire = false;
  showUV = false;
  recordDXF = false;
  recordOBJ = false;
}

void draw() {

  background(0);

  if (isIcoCreated)
  {

    image(computeOffscreen(), 0, 0);
    if (showUV)
    {
      image(ico.getUvMapImg(), 0, 0, ico.getUvMapImg().width*0.5, ico.getUvMapImg().height*0.5);
    }

    exportOBJFile();
    exportDXFFile();
  }
  else
  {
    fill(255);
    textAlign(CENTER, CENTER);
    text("Waiting for shape to display - Press 'i' to create an icosahedron", width/2, height/2);
  }
}

void initIco()
{
  println("creating icosahedron");
  nbSubdivision = 2; //max 7 - app freezes at 8
  //ico = new Icosahedron(nbSubdivision, 200, textures[0], "texVert", "texFrag", "visiteRuinart");
   ico = new Icosahedron(nbSubdivision, 200);
  ico.init();
  println("icosahedron has been created");
}

//Control Key
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
  if (key == 'i')
  {
    if (!isIcoCreated)
    {
      initIco();
      isIcoCreated = true;
    }
  }
  if (key == 'u')
  {
    showUV = !showUV;
  }

  if (key == 'd')
  {

    recordDXF = true;
  }

  if (key == 'o')
  {

    recordOBJ = true;
  }

  if (isIcoCreated)
  {
    for (int i=0; i<keyIndex.length; i++)
    {
      if (key == keyIndex[i])
      {
        int lastIndex = indexTex;
        indexTex = i;
        ico.bindTexture(textures[indexTex]);
        println("\tTexture has been change from texture["+lastIndex+"] to texture["+indexTex+"]");
      }
    }
  }
}

//control de la scene 3D [ArcBall]
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

//3D World
void showWorld(boolean etat)
{
  if (etat)
  {
    offscreen.stroke(255, 0, 0);
    offscreen.line(0, 0, 0, 100, 0, 0);
    offscreen.stroke(0, 255, 0);
    offscreen.line(0, 0, 0, 0, 100, 0);
    offscreen.stroke(0, 0, 255);
    offscreen.line(0, 0, 0, 0, 0, 100);
  }
}

//compute Light
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

//Display 3D Lights
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
//Compute Offscreen
PImage computeOffscreen()
{
  offscreen.beginDraw();
  offscreen.background(0);
  offscreen.perspective();

  offscreen.pushMatrix();
  offscreen.translate(width/2, height/2, zoom);

  sceneControl();


  lightSpecular(190, 30, 60);
  drawLight(true, 10); 
  shininess(30.0);

  showWorld(true);

  if (ico.isTextured())
  {
    offscreen.shader(ico.getTextureShader());
  }
  offscreen.shape(ico.getIcoShape());

  if (icoNormals)
  {
    offscreen.shape(ico.getNormalShape());
  }
  if (icoWire)
  {
    offscreen.shape(ico.getWireframeShape());
  }

  offscreen.popMatrix();
  offscreen.endDraw();

  return offscreen;
}

void exportOBJFile()
{
  if (recordOBJ)
  {
    println("Beging OBJ Export");
    beginRecord("nervoussystem.obj.OBJExport", "icoShape.obj");//start record obj
    //pushMatrix();
    //lights();
    translate(width/2, height/2, 0);
    //shader(ico.getTextureShader());
    shape(ico.getIcoShape());
    /* shape(ico.getNormalShape());
     shape(ico.getWireframeShape());*/
    // popMatrix();
    endRecord();
    println("OBJ Export has been done");
    recordOBJ = false;
  }
}

void exportDXFFile()
{
  if (recordDXF)
  {
    println("Beging DXF Export");
    beginRaw(DXF, "icoShape.dxf");//start record obj
    //pushMatrix();
    //lights();
    translate(width/2, height/2, 0);
    //shader(ico.getTextureShader());
    shape(ico.getIcoShape());
    /* shape(ico.getNormalShape());
     shape(ico.getWireframeShape());*/
    // popMatrix();
    endRaw();
    println("DXF Export has been done");
    recordDXF = false;
  }
}

