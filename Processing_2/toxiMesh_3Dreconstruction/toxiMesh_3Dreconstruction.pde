import processing.opengl.*;
import toxi.processing.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import java.util.Iterator;
import peasy.*;

PeasyCam cam;

sphereMesh myShape;
TriangleMesh mesh;
ToxiclibsSupport gfx;

//camera
float xCam, zCam, yCam;
float angleCam;

boolean isWireframe;
float currZoom = 1.25f;

boolean showNormals;

Vec2D scaleUV;

PImage tex;



void setup() {
  size(1080, 1920, P3D);

  cam = new PeasyCam(this, width/2, height/2, 0, 1500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(2000);

  myShape = new sphereMesh(50, 10, 30, 30);
  tex = loadImage("plop.jpg");
  scaleUV =new Vec2D(20-1, 20-1).reciprocal();

  mesh = new TriangleMesh("meshTest");
  gfx = new ToxiclibsSupport(this);
}

void draw() {
  background(255);
  lightsBehavior();
  translate(width/2, height/2);

  mesh.clear();
  myShape.run();


  //gfx.origin(new Vec3D(), 100);

  fill(255);
  //noFill();
  stroke(0, 255, 0);
  noStroke();
  //calcTextureCoordinates(mesh);
  //calcTextureCoordinates(mesh, 50, 20);
  //textureMode(NORMAL);
  //gfx.texturedMesh(mesh, tex, false);
  // gfx.meshNormalMapped(mesh, !isWireframe, showNormals ? 5 : 0);
  gfx.mesh(mesh, false, showNormals ? 5 : 0);
  frame.setTitle(" "+int(frameRate));
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



void keyPressed() {
  if (key == 'w') {
    isWireframe = !isWireframe;
  }

  if (key == 'n') {
    showNormals = !showNormals;
  }
  if (key == 's')
  {
    mesh.saveAsSTL(sketchPath(mesh.name+ ".stl"));
  }
}

void calcTextureCoordinates(TriangleMesh mesh) {
  for (Face f : mesh.getFaces()) {
    f.uvA=calcUV(f.a);
    f.uvB=calcUV(f.b);
    f.uvC=calcUV(f.c);
  }
}

Vec2D calcUV(Vec3D p) {
  Vec3D s=p.copy();
  Vec2D uv=new Vec2D(s.y/TWO_PI, 1-(s.z/PI+0.5));
  // make sure longitude is always within 0.0 ... 1.0 interval
  if (uv.x<0) uv.x+=1;
  else if (uv.x>1) uv.x-=1;
  return uv;
}

void calcTextureCoordinates(TriangleMesh mesh, int w, int h) {

  AABB bbox = mesh.getBoundingBox();
  Vec3D min = bbox.getMin();
  Vec3D max = bbox.getMax();

  float mx = 1.0/(max.x - min.x);
  float mz = 1.0/(max.z - min.z);

  for (Face f : mesh.getFaces()) {
    f.uvA = new Vec2D((f.a.x+min.x)*mx, (f.a.z+min.z)*mz);
    f.uvB = new Vec2D((f.b.x+min.x)*mx, (f.b.z+min.z)*mz);
    f.uvC = new Vec2D((f.c.x+min.x)*mx, (f.c.z+min.z)*mz);
  }
}

