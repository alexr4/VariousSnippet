import gab.opencv.*;
import java.awt.Rectangle;

OpenCV opencv;
Rectangle[] faces;

void initFaceDetect(PImage source)
{
   opencv = new OpenCV(this, source);

  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  faces = opencv.detect();
}

PImage getFaceImage()
{
  return opencv.getInput();
}

PShape getFace()
{
  PShape face = createShape();
  
  face.beginShape(TRIANGLE);
  face.stroke(255);
  face.noFill();
   for (int i = 0; i < faces.length; i++) 
   {
     PVector v0 = new PVector(faces[i].x, faces[i].y);
     PVector v1 = new PVector(faces[i].x + faces[i].width, faces[i].y);
     PVector v2 = new PVector(faces[i].x, faces[i].y + faces[i].height);
     PVector v3 = new PVector(faces[i].x + faces[i].width, faces[i].y + faces[i].height);
     
     face.vertex(v0.x, v0.y);
     face.vertex(v1.x, v1.y);
     face.vertex(v2.x, v2.y);
     
     face.vertex(v2.x, v2.y);
     face.vertex(v1.x, v1.y);
     face.vertex(v3.x, v3.y);
  }
  face.endShape();
  
  return face;
}

void drawShape()
{
  shape(getFace());
}