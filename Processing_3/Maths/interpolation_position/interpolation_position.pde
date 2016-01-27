float sx, sy;
float ex, ey;
float speed;
float move;
float x, y;

void setup() {
  size(600, 600);


  sx = random(width);
  sy = random(height);
  ex = random(width);
  ey = random(height);
  speed = random(0.001, 0.05);
  move = 0;
}


void draw() {
  background(40);

  noFill();
  stroke(255);

  line(sx, sy, ex, ey);
  text("Start", sx + 10, sy);
  text("End", ex + 10, ey);


  goToPoint(ex, ey);

  ellipse(x, y, 10, 10);
  updateMove();
}

void goToPoint(float x_, float y_)
{
  float progress = move;

  x = lerp(sx, ex, progress);     // we can calculate x and y separately
  y = lerp(sy, ey, progress);
}

void updateMove()
{
  if (move < 1)
  {
    move+= speed;
  }
  else
  {
    sx = random(width);
    sy = random(height);
    ex = random(width);
    ey = random(height);
    speed = random(0.001, 0.05);
    move = 0;
  }
}