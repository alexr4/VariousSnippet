PImage checkerBoard;
int imgWidth, imgHeight;
float imgRatio;
float scale;



void setup()
{
  size(1280, 720, P3D);
  //fullScreen(P3D, 2);
  
  checkerBoard = loadImage("Vader2.jpg");
  imgWidth = checkerBoard.width;
  imgHeight = checkerBoard.height;
  imgRatio = (float) imgWidth / (float) imgHeight;
  scale = 0.5;
}

void draw()
{
  background(255);
  
  
  //Crop without Rotate
  int nw0_ = imgWidth/2;
  float nr0_ = (float) 1920 / (float) 1080;
  int nh0_ = int (nw0_ / nr0_);
  int bx0_ = checkerBoard.width/2;
  int by0_ = checkerBoard.height/2;
  
   //Crop with Rotate
  float nr1_ = (float) 1920 / (float) 1080;
  int nh1_ = imgWidth;
  int nw1_ = int(imgWidth / nr1_);
  //PImage ncb1 = new PImage(nw1_, nh1_);
  int bx1_ = (imgHeight - nw1_) / 2;
  int by1_ = 0;  
  
  PImage ncb0 = cropImage(bx0_, by0_, nw0_, nh0_, checkerBoard);
  PImage ncb1 = cropRotatedImage(bx1_, by1_, nw1_, nh1_, checkerBoard);

  //display
  image(checkerBoard, 0, 0, imgWidth * scale, imgHeight * scale);
  image(ncb0, imgWidth * scale + 10, 0, nw0_ * scale, nh0_ * scale);
  image(ncb1, imgWidth * scale + 10, nh0_ * scale + 10, nw1_ * scale, nh1_ * scale);
  
  stroke(0, 255, 0);
  noFill();
  rect(by1_, bx1_ * scale, nh1_ * scale, nw1_ * scale);
}