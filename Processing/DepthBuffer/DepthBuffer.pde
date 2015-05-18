//zBuffer copy implementation following the double renderScene methode by codeanticode found on http://forum.processing.org/two/discussion/2530/creating-a-depth-of-field-shader-how-to-associate-depth-information-with-a-pgraphics-object/p1

PGraphics bufferTexColorScreen;
PGraphics bufferDepthScreen;
PShader depthShader;

void setup()
{
  size(1500, 500, P3D);
  smooth();

  //buffers
  bufferTexColorScreen = createGraphics(500, height, P3D);
  bufferDepthScreen = createGraphics(500, height, P3D);
  //bufferTexColorScreen.smooth(8);
  //bufferDepthScreen.smooth(8);


  depthShader = loadShader("depthFrag.glsl", "depthVert.glsl");
  depthShader.set("screen", (float)width, (float)height, (float)0, (float)600);
  bufferDepthScreen.shader(depthShader);


  randomSeed(1000);
}

void draw()
{
  // background(0);
  renderScene(bufferTexColorScreen, false);
  renderScene(bufferDepthScreen, true);

  image(bufferTexColorScreen, 0, 0);
  image(bufferDepthScreen, bufferTexColorScreen.width, 0);
}

void renderScene(PGraphics buff, boolean isDepth)
{
  float radius = 100;
  randomSeed(1000); 

  buff.beginDraw();
  buff.background(0);
  buff.pushMatrix();
  buff.translate(buff.width/2, buff.height/2);
  //
  buff.fill(0, 160, 255);

  if (isDepth)
  {
    buff.noStroke();
  } else
  {
    //buff.stroke(255, 0, 255);
    buff.noStroke();
    buff.lights();
  }

  for (int i=0; i<20; i++)
  {
    float x = random(-radius, radius);
    float y = random(-radius, radius);
    float z = random(-radius, radius);

    buff.pushMatrix();
    buff.translate(x, y, z);
    buff.sphere(radius);
    buff.popMatrix();
  }
  buff.popMatrix();
  buff.endDraw();
}

