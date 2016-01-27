import peasy.*;

PeasyCam cam;

Grid myGrid;


void setup() {
  size(800, 800, P3D);
  smooth(8);
  cam = new PeasyCam(this, 0, 0, 0, 1000);

  int rows = 100;
  int cols = 100;
  int resX = 100;
  int resY = 100;
  int sizeX = cols * resX;
  int sizeY = rows * resY;

  myGrid = new Grid(new PVector(sizeX/2*-1, sizeY/2*-1, 0), cols, rows, resX, resY);
}

void draw() {
  background(0);
  //lights();
  lightsBehavior();
  myGrid.run();
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