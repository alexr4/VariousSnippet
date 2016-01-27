import peasy.*;
import java.nio.IntBuffer;

//shader
IntBuffer envMapTextureID;
PShader envShader;
PImage envTex;
PShape cubeMapObj;
PMatrix3D cameraMatrix;

//environment data
PImage envMap;

//3D Shape
PShape carObj;
String fileFolder = "/car/";

//Camera data
PeasyCam cam;

//app information
String version = "0.01";
String appName = "CarTest_v"+version;
int pWidth = 1280;
int pHeight = 720;

//others
float vAngle = 0.01;
float angle;


void setup()
{
  size(pWidth, pHeight, P3D);
  cam = new PeasyCam(this, 0, 0, 0, 180);
  /*load3DObj();
  scale3DObj(25);*/
  
  //shader
  cameraMatrix = new PMatrix3D();
  envMap = loadImage("city2.jpg");
  generateCubeMap();
  cubeMapObj = texturedCube(envMap, 1000);
  envShader = loadShader("env_frag.glsl", "env_vert.glsl");
  envShader.set("cubemap", 1);
  envShader.set("fresnel", 0.75f);
}

void draw()
{
  background(0);
  displayCubeMap();
  drawAxis(25);
  
  shader(envShader);
  
  pushMatrix();
  translate(0, 25, 0);
  rotateAxis();
  //shape(carObj);
  noStroke();
  sphere(100);
  popMatrix();
  resetShader();
  
  setTitleToFrame();
}

void rotateAxis()
{
  rotateY(angle);
  angle += vAngle;
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

void load3DObj()
{
  println("Load car.obj");
  carObj = loadShape(fileFolder+"Peugeot_207.obj");
  carObj.disableStyle();
  carObj.rotateX(PI);
  println("Car.obj has beed loaded with "+carObj.getChildCount()+" child object and "+(carObj.getChildCount() * 3)+" vertices");
}

void scale3DObj(float scale)
{
  PVector origine = new PVector(0,0,0);

  for (int c=0; c<carObj.getChildCount (); c++)
  {
    PShape child = carObj.getChild(c);

    PVector v0 = child.getVertex(0);
    PVector v1 = child.getVertex(1);
    PVector v2 = child.getVertex(2);

    PVector newV0 = PVector.div(v0, scale);
    PVector newV1 = PVector.div(v1, scale);
    PVector newV2 = PVector.div(v2, scale);
    
    
    child.setVertex(0, newV0);
    child.setVertex(1, newV1);
    child.setVertex(2, newV2);
    
  }
   println("\t3D object has been scaled down"); //nb : each child = one face
}

void setTitleToFrame()
{
  frame.setTitle(appName+" fps : "+int(frameRate));
}

PVector getCamPos(PeasyCam c)
{
  float[] camPosArray = c.getPosition();
  return new PVector(camPosArray[0], camPosArray[1], camPosArray[2]);
}

PVector getCamRotation(PeasyCam c)
{
  float[] camRotArray = c.getRotations();
  return new PVector(camRotArray[0], camRotArray[1], camRotArray[2]);
}


