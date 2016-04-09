// ==================================================
// Multi Windows texture Binding
// Create new window synchronized with the main context (PApplet) allowing
// to bind OpenGL PGraphics as texture.
// Implementation by BonjourLab based on a code from GoToLoop (2015-Oct-27)
// forum.Processing.org/two/discussion/13233/render-on-window-graphics-in-another
// www.bonjour-lab.com
// ==================================================

PGraphics texture1, texture2, texture3;


ChildApplet child1;
ChildApplet child2;

void settings() {
  size(500, 500, P3D);
  smooth();
}

void setup()
{

  //init Child Applet
  surface.setTitle("Main Applet");  
  child1 = new ChildApplet(1, width, height, new PVector(width, 0));
  child2 = new ChildApplet(2, width, height, new PVector(width * 2, 0));


  //init Texture
  texture1 = createGraphics(width, height, P3D);
  texture2 = createGraphics(width, height, P3D);
  texture3 = createGraphics(width, height, P3D);


  runSketch(platformNames, child1);
  runSketch(platformNames, child2);
  surface.setLocation(0, 0);
}

void draw()
{
  synchronized (DXF) //All openGL drawing need to be synchronized
  {
    computeTexture(texture1, "Max");
    computeTexture(texture2, "Guta");
    computeTexture(texture3, "Jeanf");
    
    //send PGraphics to child PApplet
    child1.bindTexture(texture2);
    child2.bindTexture(texture3);
  }

  background(0);
  image(texture1, 0, 0);
}

public void computeTexture(PGraphics tex_, String txt_)
{
  tex_.beginDraw();
  tex_.background(noise(frameCount * 0.1)  * 255);
  tex_.textAlign(CENTER);
  tex_.textSize(20);
  tex_.text(txt_, tex_.width/2, tex_.height/2);
  tex_.endDraw();
}