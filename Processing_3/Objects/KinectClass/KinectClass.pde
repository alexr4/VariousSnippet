import peasy.*;
PeasyCam cam;

//Kinect
Kinect kinect;


void setup()
{
  size(1280, 720, P3D);
  smooth(8);
  appParameter();

  kinect = new Kinect(this, 0, 4500);
  kinect.setGridResolution(1);


  //peasyCam
  cam = new PeasyCam(this, 0, 0, -1000, 500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(5000);
}

void draw()
{
  background(0);
  lights();
  kinect.computePinholeCamaraModelonBodyTrack();
  //kinect.computePinholeCamaraModel();
  //kinect.compute3DNormalizeSkeleton(); 


  kinect.directDisplayFrustum();

  //Point Cloud
  //kinect.directDisplayDepth3DData();
  //kinect.directDisplayColor3DData();
  //kinect.directDisplayColor2DData();

  //3D Shape
  //kinect.directDisplay3DDepthShape();
  //kinect.directDisplay3DColorShape();
  //kinect.directDisplay2DColorShape();


  //kinect.display2DDepthSkeleton(-kinect.getInfaredWidth()/2, -kinect.getInfaredHeight()/2, kinect.getInfaredWidth(), kinect.getInfaredRatio()); 
  //kinect.display2DColorSkeleton(-kinect.getColorWidth()/2, -kinect.getColorHeight()/2, kinect.getColorWidth(), kinect.getColorRatio()); 
  //kinect.display3DSkeleton(kinect.getColorRatio()); 

  drawAxis(40, "RVB");

  cam.beginHUD();
  kinect.showDebug(0, 0, 0.1);
  showDebug();
  cam.endHUD();
}

void keyPressed()
{
}