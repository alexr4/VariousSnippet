static class ChildApplet extends PApplet {
  PImage tmp;
  int childWidth = 200;
  int childHeight = 200;
  int index = 0;
  PVector location = new PVector(0, 0);

  public ChildApplet() {
  }

  public ChildApplet(int childWidth_, int childHeight_)
  {
    childWidth = childWidth_; 
    childHeight = childHeight_;
  }

  public ChildApplet(int index_, int childWidth_, int childHeight_)
  {
    index = index_;
    childWidth = childWidth_; 
    childHeight = childHeight_;
  }

  public ChildApplet(int index_, int childWidth_, int childHeight_, PVector location_)
  {
    index = index_;
    childWidth = childWidth_; 
    childHeight = childHeight_;
    location = location_;
  }

  public void settings() {
    size(childWidth, childHeight);
    smooth();
  }
  public void setup() { 
    surface.setTitle("Child : "+index);
    surface.setSize(childWidth, childHeight);
    surface.setLocation((int) location.x, (int) location.y);  
    tmp = new PImage(childWidth, childHeight);  
  }

  public void draw() {
    synchronized (DXF)
    {
      background(0);
      imageMode(CORNER);
      image(tmp, 0, 0);
    }
  }
  
  public void bindTexture(PGraphics pg)
  {
    tmp = pg.get();
  }
}