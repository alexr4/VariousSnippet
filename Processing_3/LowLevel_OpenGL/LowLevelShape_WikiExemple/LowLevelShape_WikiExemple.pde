// from : https://github.com/processing/processing/wiki/Advanced-OpenGL

import com.jogamp.opengl.GL2;  // Processing 3
//import javax.media.opengl.GL2;  // Processing 2

float a;

PGraphicsOpenGL pg; 
PGL pgl;
GL2 gl;

float[] projMatrix;
float[] mvMatrix;

void setup() {
  size(800, 600, P3D);
  projMatrix = new float[16];
  mvMatrix = new float[16]; 
}

void draw() {
  background(255);

  pg = (PGraphicsOpenGL) g;
  pgl = beginPGL();  
  gl = ((PJOGL) pgl).gl.getGL2();

  copyMatrices();  
  // Do some things with gl.xxx functions here.
  // For example, the program above is translated into:
  gl.glColor4f(0.7, 0.7, 0.7, 0.8);
  gl.glTranslatef(width/2, height/2, 0);
  gl.glRotatef(a, 1, 0, 0);
  gl.glRotatef(a*2, 0, 1, 0);
  gl.glRectf(-200, -200, 200, 200);
  gl.glRotatef(90, 1, 0, 0);
  gl.glRectf(-200, -200, 200, 200);

  endPGL();

  a += 0.5;
}

// Copies the current projection and modelview matrices from Processing to OpenGL.
// It needs to be done explicitly, otherwise GL will use identity matrices by default!
void copyMatrices() {
  PGraphicsOpenGL pg = (PGraphicsOpenGL) g;

  gl.glMatrixMode(GL2.GL_PROJECTION);
  projMatrix[0] = pg.projection.m00;
  projMatrix[1] = pg.projection.m10;
  projMatrix[2] = pg.projection.m20;
  projMatrix[3] = pg.projection.m30;

  projMatrix[4] = pg.projection.m01;
  projMatrix[5] = pg.projection.m11;
  projMatrix[6] = pg.projection.m21;
  projMatrix[7] = pg.projection.m31;

  projMatrix[8] = pg.projection.m02;
  projMatrix[9] = pg.projection.m12;
  projMatrix[10] = pg.projection.m22;
  projMatrix[11] = pg.projection.m32;

  projMatrix[12] = pg.projection.m03;
  projMatrix[13] = pg.projection.m13;
  projMatrix[14] = pg.projection.m23;
  projMatrix[15] = pg.projection.m33;

  gl.glLoadMatrixf(projMatrix, 0);

  gl.glMatrixMode(GL2.GL_MODELVIEW);
  mvMatrix[0] = pg.modelview.m00;
  mvMatrix[1] = pg.modelview.m10;
  mvMatrix[2] = pg.modelview.m20;
  mvMatrix[3] = pg.modelview.m30;

  mvMatrix[4] = pg.modelview.m01;
  mvMatrix[5] = pg.modelview.m11;
  mvMatrix[6] = pg.modelview.m21;
  mvMatrix[7] = pg.modelview.m31;

  mvMatrix[8] = pg.modelview.m02;
  mvMatrix[9] = pg.modelview.m12;
  mvMatrix[10] = pg.modelview.m22;
  mvMatrix[11] = pg.modelview.m32;

  mvMatrix[12] = pg.modelview.m03;
  mvMatrix[13] = pg.modelview.m13;
  mvMatrix[14] = pg.modelview.m23;
  mvMatrix[15] = pg.modelview.m33;
  gl.glLoadMatrixf(mvMatrix, 0);
}