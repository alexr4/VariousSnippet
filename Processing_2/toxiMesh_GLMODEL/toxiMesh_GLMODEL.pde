import processing.opengl.*;
import javax.media.opengl.*;
import codeanticode.glgraphics.*;
import toxi.processing.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import java.util.Iterator;

Grid myGrid;
TriangleMesh mesh;
ToxiclibsSupport gfx;

//camera
float xCam, zCam, yCam;
float angleCam;

//GLGraphics
GLModel modelMesh;


void setup() {
  size(800, 800, GLConstants.GLGRAPHICS);

  myGrid = new Grid(200, 200, 5, 5);

  mesh = new TriangleMesh("meshTest");
  myGrid.run();
  modelMesh = convertGLModel(mesh);
  gfx = new ToxiclibsSupport(this);
}

void draw() {
  /*
   mesh.clear();
   myGrid.run();
   fill(255);
   //noStroke();
   strokeWeight(1);
   stroke(255, 50);
   //gfx.mesh(mesh);
   */


  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();
  background(0);

  cameraBehavior();

  //rotateX( map(mouseY, 0, height, -PI, PI) );
  //rotateY( map(mouseX, 0, width, -PI, PI) );


  lightsBehavior();
  
  renderer.gl.glEnable(GL.GL_LIGHTING);
  renderer.gl.glDisable(GL.GL_COLOR_MATERIAL);


  modelMesh.render();
  renderer.endGL();
}

void keyPressed()
{
  if (key == 's')
  {
    mesh.saveAsSTL(sketchPath(mesh.name+ ".stl"));
  }
}

void cameraBehavior()
{
  perspective(radians(70), float(width)/float(height), 10, -1000.0); // Field of view(angle de vue), ratio image, near field limit, far field limit

  //rotation Camera
  xCam = width/2*cos(radians(angleCam));
  zCam = 100*sin(radians(angleCam));
  yCam = height/2*sin(radians(angleCam));
  angleCam += radians(10.0);

  //Camera View
  beginCamera(); //
  camera(xCam, yCam, 1000, width/2, height/2, 0, 0, 1, 0); //posX, posY, posZ, cibleX, cibleY, cibleZ, OrientationX, OrientationY, OrientationZ
  endCamera();
}

void lightsBehavior()
{
  //lights();
  
  pointLight(51, 102, 126, mouseX, mouseY, 0);
  pointLight(0, 0, 255, width/2, height/2, 100);
  //pointLight(255, 0, 0, width/2, -height/2, 0);  
  pointLight(0, 255, 160, width/2, -height, 200);
 
}

// ----------------------------------------------------------------

GLModel convertGLModel(TriangleMesh mesh)
{
  float[] vertices=mesh.getMeshAsVertexArray();
  int nbVertices = vertices.length/4;

  float[] normals=mesh.getVertexNormalsAsArray();

  GLModel m = new GLModel(this, nbVertices, TRIANGLES, GLModel.STATIC);

  m.beginUpdateVertices();
  for (int i = 0; i < nbVertices; i++)
  { 
    m.updateVertex(i, vertices[4*i], vertices[4*i+1], vertices[4*i+2]);
  }
  m.endUpdateVertices(); 


  m.initNormals();
  m.beginUpdateNormals();
  for (int i = 0; i < nbVertices; i++) {
    m.updateNormal(i, normals[4 * i], normals[4 * i + 1], normals[4 * i + 2]);
  }
  m.endUpdateNormals(); 


  return m;
}

