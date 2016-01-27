import javax.media.opengl.GL2;
import java.nio.*;
float[] projMatrix;
float[] mvMatrix;
 
PGraphicsOpenGL pgl;
GL2 gl;
int quadlength;
int[] quad_vbo = new int[1];
int SIZEOF_FLOAT = 4;
 
void setup() {
 size(300,300,OPENGL);
 pgl = (PGraphicsOpenGL) g;
 gl = pgl.beginPGL().gl.getGL2();
 projMatrix = new float[16];
 mvMatrix = new float[16];
 initVBO();
}
void draw() {
 loadMatrix();
 pgl.beginPGL();
 gl.glEnableClientState(GL2.GL_VERTEX_ARRAY);
 gl.glBindBuffer( GL2.GL_ARRAY_BUFFER, quad_vbo[0]);
 gl.glVertexPointer(2,GL2.GL_FLOAT,0,0);
 gl.glDrawArrays( GL2.GL_QUADS, 0, quadlength);
 gl.glBindBuffer( GL2.GL_ARRAY_BUFFER, 0);
 gl.glDisableClientState(GL2.GL_VERTEX_ARRAY);
 pgl.endPGL();
}
 
void initVBO() {
 ArrayList quadvbo = new ArrayList();
 quadvbo.add( new ms_vector2(20,20));
 quadvbo.add( new ms_vector2(200,20));
 quadvbo.add( new ms_vector2(200,200));
 quadvbo.add( new ms_vector2(20,200));
 
 quadlength = quadvbo.size();
 if (quadlength > 0) {
   pgl.beginPGL();
   gl.glGenBuffers( 1, quad_vbo, 0 );
   gl.glBindBuffer( GL2.GL_ARRAY_BUFFER, quad_vbo[0] );
   gl.glBufferData( GL2.GL_ARRAY_BUFFER, quadlength * 2 * SIZEOF_FLOAT, ms_vector2_to_float_buffer( quadvbo ), GL2.GL_STATIC_DRAW );
   gl.glBindBuffer( GL2.GL_ARRAY_BUFFER, 0);
   pgl.endPGL();
   quadvbo = null;
 }
}
 
class ms_vector2
{
 float x, y;
 
 // constructor
 ms_vector2()
 {
   this.x = 0;
   this.y = 0;
 }
 
 ms_vector2( float _x, float _y)
 {
   this.x = _x;
   this.y = _y;
 }
}
 
// buffer converters
FloatBuffer ms_vector2_to_float_buffer( ArrayList _vector )
{
 FloatBuffer a  = ByteBuffer.allocateDirect( _vector.size() * 2 * SIZEOF_FLOAT ).order(ByteOrder.nativeOrder()).asFloatBuffer();
 
 for( int i = 0; i < _vector.size(); i++ )
 {
   ms_vector2 v = (ms_vector2) _vector.get( i );
   a.put( v.x );
   a.put( v.y );
 }
 a.rewind();
 return a;
}
 
 
void loadMatrix() {
  gl.glMatrixMode(GL2.GL_PROJECTION);
  projMatrix[0] = pgl.projection.m00;
  projMatrix[1] = pgl.projection.m10;
  projMatrix[2] = pgl.projection.m20;
  projMatrix[3] = pgl.projection.m30;
 
  projMatrix[4] = pgl.projection.m01;
  projMatrix[5] = pgl.projection.m11;
  projMatrix[6] = pgl.projection.m21;
  projMatrix[7] = pgl.projection.m31;
 
  projMatrix[8] = pgl.projection.m02;
  projMatrix[9] = pgl.projection.m12;
  projMatrix[10] = pgl.projection.m22;
  projMatrix[11] = pgl.projection.m32;
 
  projMatrix[12] = pgl.projection.m03;
  projMatrix[13] = pgl.projection.m13;
  projMatrix[14] = pgl.projection.m23;
  projMatrix[15] = pgl.projection.m33;
 
  gl.glLoadMatrixf(projMatrix, 0);
 
  gl.glMatrixMode(GL2.GL_MODELVIEW);
  mvMatrix[0] = pgl.modelview.m00;
  mvMatrix[1] = pgl.modelview.m10;
  mvMatrix[2] = pgl.modelview.m20;
  mvMatrix[3] = pgl.modelview.m30;
 
  mvMatrix[4] = pgl.modelview.m01;
  mvMatrix[5] = pgl.modelview.m11;
  mvMatrix[6] = pgl.modelview.m21;
  mvMatrix[7] = pgl.modelview.m31;
 
  mvMatrix[8] = pgl.modelview.m02;
  mvMatrix[9] = pgl.modelview.m12;
  mvMatrix[10] = pgl.modelview.m22;
  mvMatrix[11] = pgl.modelview.m32;
 
  mvMatrix[12] = pgl.modelview.m03;
  mvMatrix[13] = pgl.modelview.m13;
  mvMatrix[14] = pgl.modelview.m23;
  mvMatrix[15] = pgl.modelview.m33;
  gl.glLoadMatrixf(mvMatrix, 0);
}
