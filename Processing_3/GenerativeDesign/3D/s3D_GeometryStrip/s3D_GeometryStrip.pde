ribbon obj;


void setup()
{
  size(1200, 600, P3D);

  obj = new ribbon(10, 100, 50, new PVector((width-(100*10))/2, height/2, 0));
}

void draw()
{
  background(255);
  //translate(0, height/2);
  //mouseMoved();
  obj.draw3D();
  stroke(255,0,0);
}

void mouseMoved()
{
  rotateX(radians(mouseY));
  rotateY(radians(mouseX));
}