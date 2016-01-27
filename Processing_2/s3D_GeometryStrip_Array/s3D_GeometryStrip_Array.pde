import processing.opengl.*;

ArrayList<ribbon> obj;

int nbRibbon;


void setup()
{
  size(1200, 600, OPENGL);

  obj = new ArrayList<ribbon>();
  nbRibbon = int(random(2, 8));
  for (int i=0; i<nbRibbon; i++)
  {
    int nbFace = int(random(5, 20));
    int w = int(random(10, 100));    
    int h = int(random(5, 50));
    PVector loc = new PVector(random(width/2), random(height), 0);

    obj.add(new ribbon(nbFace, w, w, loc));
  }
}

void draw()
{
  background(0);
  //translate(0, height/2);
  //mouseMoved();

  for (ribbon r : obj)
  {
    r.draw3D();
  }
}

void mouseMoved()
{
  rotateX(radians(mouseY));
  rotateY(radians(mouseX));
}

