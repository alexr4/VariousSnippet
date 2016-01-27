import java.awt.Color;

void setup()
{
  size(500, 500);
}

void draw()
{
  background(255);
  
  float value = map(mouseX, 0, width, 0, 360);
  float hue = map(value, 0, 360, 0, 1);

  color c0 = Color.HSBtoRGB(hue, 1, 1); //Color.HSBtoRGB(h, s, b) où h, s et b sont comrpis entre 0 et 1f;
  
  println(hue, red(c0), green(c0), blue(c0));
  
  fill(c0);
  rect(0,0, 100, 100);
}