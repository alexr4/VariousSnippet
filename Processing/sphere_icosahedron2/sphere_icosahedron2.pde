/*
 Textured Sphere by Amnon Owed (April 2013) Updated by Alexandre Rivaux (Bonjour, interactive lab);
 ---------------------------                     --------------------------                     
 https://github.com/AmnonOwed                      http://www.bonjour-lab.com
 http://vimeo.com/amnon                                http://www.vimeo.com/bonjour
 
 Creating a textured sphere by subdividing an icosahedron.
 Using the GLGraphics' GLModel to store and display the shape.
 Using Offscreen in order to generate a dynamic texture
 
 The benefits of the current creation method are:
 1. Even distribution of vertices over the sphere
 2. No seam or pole problems in the texture coordinates
 
 MOUSE  = arcball around the sphere
 
 w = toggle wireframe or textured view of the GL Model
 
 Built with Processing 1.5.1 + GLGraphics 1.0.0
 */

import processing.opengl.*;
import codeanticode.glgraphics.*;
import codeanticode.gsvideo.*;
import javax.media.opengl.*;
import java.util.HashSet;
import java.util.*; 

//Volume Variables
PApplet parent;
Icosahedron ico;
int nbSubdivision;
GLGraphics renderer;
GLModel icoSphere;
boolean wireframe, icoWire, icoNormals, icoVertices;


//Scene Variables
float zoom = 100;
PVector rotation = new PVector();
PVector velocity = new PVector();
float rotationSpeed = 0.02;

PVector acceleration= new PVector();
;
PVector orientation;
float sens, sens2;
float amplitude;

int nbCharacters;
float p1, p2, p3;
int f;

// --------------------------------------------------------

void setup() {
  size(960, 720, GLConstants.GLGRAPHICS);

  parent = this;

  nbCharacters = 500;  
  f = round((sqrt((nbCharacters-2)/10.0)-1)); //Frequency of Icosahedron : f = sqrt((Vertices-2)/10)

  renderer = (GLGraphics) g;

  nbSubdivision = f;
  ico = new Icosahedron(nbSubdivision, 200);
  icoSphere = createIcosahedron(ico);


  amplitude = 0.1;

  icoNormals = false;
  icoWire = false;
  icoVertices = false;
}

void draw() {

  background(0);

  pushMatrix();
  translate(width/2, height/2);

  sceneControl();

  showWorld(true);
  //Begin GLGraphics Renderer
  renderer.beginGL();
//  GL gl = renderer.gl;
  //show or not the wireframe of the GLModel
  if (!wireframe) { 
  //  gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_FILL );
  }
  else { 
    //gl.glPolygonMode(GL.GL_FRONT_AND_BACK, GL.GL_LINE);
  }

  //Render the sphere
  renderer.model(icoSphere);
  renderer.endGL(); //end Renderer


  //Debug : show the icosahedron create befor the GLModel
  if (icoNormals)
  {
    ico.displayNormals(new PVector(0, 0, 0));
  }
  if (icoWire)
  {
    ico.displayFace();
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
    zoom -=3;
  }
  if (key == '+')
  {
    zoom += 3;
  }

  if (key == 'w') { 
    wireframe = !wireframe;
  }
  if (key == 'n')
  {
    icoNormals = !icoNormals;
  }
  if (key == 'i')
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

  orientation = new PVector(0, sens*amplitude); //sens2*amplitude 

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
    stroke(255, 0, 0);
    line(0, 0, 0, 100, 0, 0);
    stroke(0, 255, 0);
    line(0, 0, 0, 0, 100, 0);
    stroke(0, 0, 255);
    line(0, 0, 0, 0, 0, 100);
  }
}

