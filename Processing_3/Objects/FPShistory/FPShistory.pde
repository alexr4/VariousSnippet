FPSTracking fpsTracker;

void setup()
{
  size(500, 500);
  float w = 100;
  float h = 100;
  fpsTracker = new FPSTracking(floor(w), 60,  w, h);
}

void draw()
{
  background(255);

  line(0, height/2, width, height/2);
  line(width/2, 0, width/2, height); 
  fpsTracker.run(frameRate);
  
  imageMode(CENTER);
  image(fpsTracker.getImageTracker(), width/2, height/2);
}

void mousePressed()
{
  fpsTracker.setTrackerDimension(random(width), random(height));
}