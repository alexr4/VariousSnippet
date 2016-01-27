PVector A, B, C;

void setup()
{
  size(500, 500);
  initTriangle();
}

void draw()
{
  background(255);

  //1-find bisector ABC & BCA
  PVector D = findBisector(A, B, C);
  PVector E = findBisector(B, C, A);

  //2-find intersection point beetween BD and CE
  PVector intersectionPoint = findIntersection(B, D, C, E);

  //3-find inscribed radius
  float radius = findInscribedRadius(A, B, C);

  //Draw original Triangle
  noFill();
  stroke(0);
  beginShape(TRIANGLES);
  vertex(A.x, A.y);
  vertex(B.x, B.y);
  vertex(C.x, C.y);
  endShape();

  //Draw bisectors
  stroke(255, 0, 0);
  line(D.x, D.y, B.x, B.y);
  line(E.x, E.y, C.x, C.y);

  //Draw inscribed Circle & Radius
  noFill();
  stroke(0, 0, 255);
  ellipse(intersectionPoint.x, intersectionPoint.y, radius*2, radius*2);
  line(intersectionPoint.x, intersectionPoint.y, intersectionPoint.x + radius, intersectionPoint.y);
  noStroke();
  fill(0, 255, 0);
  ellipse(intersectionPoint.x, intersectionPoint.y, 10, 10);
  
  fill(0);
  text("A", A.x - 10, A.y + 10);
  text("B", B.x - 10, B.y - 10);
  text("C", C.x + 10, C.y + 10);
  fill(255, 0, 0);
  text("D", D.x - 10, D.y + 10);
  text("E", E.x - 10, E.y - 10);
  fill(0, 0, 255);
  text("r", intersectionPoint.x + (radius / 2), intersectionPoint.y - 10);
}

void initTriangle()
{
  A = new PVector(random(width/2), random(height/2, height));
  B = new PVector(random(0, width), random(height/2));
  C = new PVector(random(width/2, width), random(height/2, height));
}

void keyPressed()
{
  if (key == 'u')
  {
    initTriangle();
  }
}

PVector findIntersection(PVector a0, PVector a1, PVector b0, PVector b1)
{
  //http://paulbourke.net/geometry/pointlineplane/
  float ua = ((b1.x - b0.x) * (a0.y - b0.y) - (b1.y - b0.y) * (a0.x - b0.x)) / ((b1.y - b0.y) * (a1.x - a0.x) - (b1.x - b0.x) * (a1.y - a0.y));

  float x = a0.x + ua *(a1.x - a0.x);
  float y = a0.y + ua * (a1.y - a0.y);

  return new PVector(x, y);
}

PVector findBisector(PVector c, PVector a, PVector b)
{
  PVector ac = PVector.sub(c, a);
  PVector ab = PVector.sub(b, a);

  /*ac.normalize();
   ab.normalize();*/

  PVector ac0 = ac.get();
  ac0.mult(ab.mag());
  PVector ab0 = ab.get();
  ab0.mult(ac.mag());

  PVector d = PVector.add(ac0, ab0);

  return d;
}

float findInscribedRadius(PVector a, PVector b, PVector c)
{
  float ab = PVector.dist(a, b);
  float bc = PVector.dist(b, c);
  float ca = PVector.dist(c, a);
  float k = 0.5 * (ab + bc + ca);

  float radius = (sqrt(k * (k - ab) * (k - bc) * (k - ca))) / k;

  return radius;
}