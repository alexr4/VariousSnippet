import peasy.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.math.*;
import toxi.volume.*;
import toxi.processing.*;
import controlP5.*;
 
ToxiclibsSupport gfx;
 
PeasyCam cam;
 
VolumetricSpaceArray volume;
IsoSurface surface;
VolumetricBrush brush;
 
ControlP5 ui;
 
TriangleMesh mesh = new TriangleMesh("mesh");
 
float ISO = 0.8;
int GRID = 50;
int DIM = 300;
 
Vec3D SCALE = new Vec3D(DIM,DIM,DIM);
 
ArrayList <Point> pointCloud;
 
void setup(){
   
  size(700,700, P3D);
  smooth(4);
   
  cam = new PeasyCam(this,100);
   
  gfx=new ToxiclibsSupport(this);
   
  ui = new ControlP5(this);
  ui.setAutoDraw(false);
   
  pointCloud = new ArrayList <Point> ();
   
  volume=new VolumetricSpaceArray(SCALE,GRID,GRID,GRID);
  surface=new ArrayIsoSurface(volume);
  brush=new RoundBrush(volume,SCALE.x/2);
   
  for(int i = 0; i < 100; i++){
    
    Vec3D v = new Vec3D(random(-DIM/2,DIM/2), random(-DIM/2,DIM/2), random(-DIM/2,DIM/2));
    Point p = new Point( v);
    pointCloud.add(p);
  }
   
  ui.addSlider("ISO",0,1,ISO,20,20,300,14).setLabel("iso threshold");
}
 
void draw(){
   
  background (0);
  lights();
   
  stroke(255);
  strokeWeight(1);
  noFill();
  box(600);
   
  volume.clear();
   
  for(Point p : pointCloud){
   p.run();
   noStroke();
   
  }
  volume.closeSides();
   
  surface.reset();
  surface.computeSurfaceMesh(mesh,ISO);
  mesh.computeVertexNormals();
  fill(255);
  noStroke();
  gfx.mesh(mesh, true);
   
   if (ui.window(this).isMouseOver()) {
    cam.setActive(false);
  } else {
    cam.setActive(true);
  }
   
  gui();
  
   frame.setTitle(" "+int(frameRate));
}
 
void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  ui.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}
 
void keyPressed() {
   
   if (key=='s') {
    mesh.saveAsSTL(sketchPath(mesh.name+".stl"));
   }
    
}
 
class Point{
  
 Vec3D loc;
 float r,v,b;
 float vx, vy, vz;
   
 Point(Vec3D _loc){
  loc = _loc;
  vx = random(-5, 5);
  vy = random(-5, 5);
  vz = random(-5, 5);
 }
 
 void update()
 {
   loc.x += vx;
   loc.y += vy;
   loc.z += vz;
   
   r = map(loc.x, -DIM/2, DIM/2, 0, 255);
   v = map(loc.y, -DIM/2, DIM/2, 0, 255);
   b = map(loc.z, -DIM/2, DIM/2, 0, 255);
 }
 
 void checkEdge()
 {
   if(loc.x > DIM/2 || loc.x<-DIM/2)
   {
     vx*=-1;
   }
   
   
   if(loc.y > DIM/2 || loc.y<-DIM/2)
   {
     vy*=-1;
   }
   
   
   if(loc.z > DIM/2 || loc.z<-DIM/2)
   {
     vz*=-1;
   }
 }
  
 void run(){
    update();
    checkEdge();
    brush();
   //display();
 }
 
 void brush()
 { 
   brush.setSize(20);
   brush.drawAtAbsolutePos(loc,1);
 }
  
 void display(){
   strokeWeight(5);
   stroke(255,0,0);
   point(loc.x,loc.y,loc.z);
 }
  
  
}
