float period = 500;
float increment = TWO_PI/period;
float amplitude =  100;

void setup()
{
  size(500, 500);
}

void draw()
{
  background(40);

  fill(255, 255, 0);  
  stroke(255, 255, 0);
  text("0", 10, height/2 - 5);
  text("1", 10, height/2 - 5 - amplitude);
  text("-1", 10, height/2 - 5 + amplitude);

  line(0, height/2, width, height/2);
  line(0, height/2 - amplitude, width, height/2 - amplitude);
  line(0, height/2 + amplitude, width, height/2 + amplitude);


  stroke(255, 0, 0);
  for (int i=0; i<period; i++)
  {
    float y = height/2 - cos(i*increment) * amplitude;
    float x = i * (width / period);

    point(x, y);
  }

  stroke(0, 255, 0);
  for (int i=0; i<period; i++)
  {
    float y = height/2 - sin(i*increment) * amplitude;
    float x = i * (width / period);

    point(x, y);
  }
}