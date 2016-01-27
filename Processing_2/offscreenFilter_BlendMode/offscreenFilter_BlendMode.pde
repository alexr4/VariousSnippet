import processing.opengl.*;
import codeanticode.glgraphics.*;

String[] blendModeName = {
  "Multiply.glsl", "Screen.glsl", "Darken.glsl", "Lighten.glsl", "Difference.glsl", "Negation.glsl", "Exclusion.glsl", "Overlay.glsl", "Hard_Light.glsl", "Soft_Light.glsl", "Dodge.glsl", "Burn.glsl"
};
GLSLShader[] shader;
GLTexture tex;
GLGraphicsOffScreen offscreen;
GLModel plane;
int blendMode=0;
PImage blendImg;


void setup()
{
  size(1000, 600, GLConstants.GLGRAPHICS);
  smooth();

  blendImg = loadImage("img1.png");

  shader = new GLSLShader[blendModeName.length];
  for (int i=0; i<blendModeName.length; i++)
  {
    println(blendModeName[i]);
    shader[i] = new GLSLShader(this, "simple_vert.glsl", blendModeName[i]);
  }
  tex = new GLTexture(this, "tex2.png");
  offscreen = new GLGraphicsOffScreen(this, width, height);

  offscreen.beginDraw();
  offscreen.background(0);
  offscreen.endDraw();

  //dessin du model
  plane = new GLModel(this, 4, QUADS, GLModel.STREAM);
  plane.beginUpdateVertices();
  plane.updateVertex(0, 0, 0, 0); //index, x,y,z
  plane.updateVertex(1, width, 0, 0); //index, x,y,z
  plane.updateVertex(2, width, height, 0); //index, x,y,z  
  plane.updateVertex(3, 0, height, 0); //index, x,y,z
  plane.endUpdateVertices();

  plane.initTextures(2); // draw it with 2 textures

  //mapper la texture sur le model
  for (int indexTexture=0;  indexTexture<2; indexTexture++)
  {
    plane.beginUpdateTexCoords(indexTexture);
    plane.updateTexCoord(0, 0, 0);
    plane.updateTexCoord(1, 1, 0);
    plane.updateTexCoord(2, 1, 1);
    plane.updateTexCoord(3, 0, 1);
    plane.endUpdateTexCoords();
  }

  plane.setTexture(0, tex);
  plane.setTexture(1, offscreen.getTexture());
}

void draw()
{

  
  offscreen.beginDraw();
   offscreen.noFill();
   offscreen.stroke(255);
   offscreen.strokeWeight(20);
   image(blendImg, 0, 0);
   offscreen.endDraw();
   
   GLGraphics renderer = (GLGraphics)g;
   
   renderer.beginGL();
   
   shader[blendMode].start();
   shader[blendMode].setTexUniform("tex", tex);
   shader[blendMode].setTexUniform("mask", offscreen.getTexture());
   shader[blendMode].setIntUniform("choice", blendMode);
   renderer.model(plane);
   
   shader[blendMode].stop();
   renderer.endGL();
   
   float s = 0.25;
   noStroke();
   fill(20);
   rect(0, 0, width*s+20, height*s+100);
   image(offscreen.getTexture(), 10, 10, width*s, height*s);
   fill(255);
   textSize(15);
   text("Use spacebar to change blendMode", 10, height*s+30);
   text("_______________________________", 10, height*s+35);
   text("Blend Mode : "+blendModeName[blendMode], 10, height*s+60);
   text("FrameRate : "+frameRate, 10, height*s+85);
   //println(blendMode);
   
}


void keyReleased()
{
  if (key == ' ')
  {
    blendMode += 1;
    if (blendMode > blendModeName.length-1)
    {
      blendMode = 0;
    }
  }
}

