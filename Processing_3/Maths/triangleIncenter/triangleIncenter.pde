PVector A, B, C;
PVector incenter;

void setup()
{
  size(800, 800);
  randomTriangle();
}

void draw()
{
  background(20);
  
  //finding inCenter
  float oa = PVector.dist(B, C);
  float ob = PVector.dist(C, A);
  float oc = PVector.dist(B, A);
  float perimeter = oa + ob + oc;
  
  float iX = (oa * A.x + ob * B.x + oc * C.x) / perimeter;
  float iY = (oa * A.y + ob * B.y + oc * C.y) / perimeter;
  
  incenter = new PVector(iX, iY);
  
  //finding radius of inscribed circle
  PVector ABPerpendicular = scalarProjection(incenter, A, B);
  float inscribedRadius = PVector.dist(incenter, ABPerpendicular);
  

  noFill();
  stroke(255);
  triangle(A.x, A.y, B.x, B.y, C.x, C.y);

  noStroke();
  fill(255, 255, 0);
  ellipse(incenter.x, incenter.y, 10, 10);
  
  noFill();
  stroke(0, 255, 0);
  ellipse(incenter.x, incenter.y, inscribedRadius * 2, inscribedRadius * 2);
  
  noStroke();
  fill(255, 0, 0);
  ellipse(ABPerpendicular.x, ABPerpendicular.y, 10, 10);
}

void keyPressed()
{
  randomTriangle();
}

PVector scalarProjection(PVector p, PVector a, PVector b) {
  PVector ap = PVector.sub(p, a);
  PVector ab = PVector.sub(b, a);
  ab.normalize(); // Normalize the line
  ab.mult(ap.dot(ab));
  PVector normalPoint = PVector.add(a, ab);
  return normalPoint;
}

void randomTriangle()
{
  A = new PVector(random(width), random(height));
  B = new PVector(random(width), random(height));
  C = new PVector(random(width), random(height));
}