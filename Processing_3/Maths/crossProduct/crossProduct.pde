PVector a, b;


void setup() {
  size(600, 360);

  a = new PVector(random(width), random(height));
  b = new PVector(random(width), random(height));
}

void draw() {
  background(255);

  pushStyle();
  PVector mouse = new PVector(mouseX, mouseY);

  stroke(0);
  strokeWeight(2);
  line(a.x, a.y, b.x, b.y);
  line(a.x, a.y, mouse.x, mouse.y);
  fill(0);
  ellipse(a.x, a.y, 8, 8);
  ellipse(b.x, b.y, 8, 8);
  ellipse(mouse.x, mouse.y, 8, 8);

  PVector norm = scalarProjection(mouse, a, b);
  strokeWeight(1);
  stroke(50);
  line(mouse.x, mouse.y, norm.x, norm.y);

  line(mouse.x, mouse.y, b.x, b.y);

  noStroke();
  fill(255, 0, 0);
  ellipse(norm.x, norm.y, 16, 16);  
  popStyle();

  
  PVector ba = PVector.sub(a, b);
  PVector bc = PVector.sub(mouse, b);
  PVector cross = ba.cross(bc);
  println(degrees(PVector.angleBetween(ba,bc)));
  
  PVector crossN = cross;
  crossN.div(500);
  stroke(255, 0, 255);
  noFill();
  line(10, height/2, 10, height/2 + crossN.z);
  fill(255, 0, 255);
  noStroke();
  ellipse(10, height/2 + crossN.z, 5, 5);
  
  println(cross);
  if(cross.z > 0)
  {
    println("left");
  }
  else
  {
    println("right");
  }
 
 
  fill(0);
  text("a", a.x+5, a.y);
  text("b", b.x+5, b.y);
  text("c", mouseX+5, mouseY);
  text("sp", norm.x+5, norm.y);
  text("cross Product BA BC : "+cross.z, 15, height/2, 70, 100);
}

void keyPressed()
{
  a = new PVector(random(width), random(height));
  b = new PVector(random(width), random(height));
}

PVector scalarProjection(PVector p, PVector a, PVector b) {
  PVector ap = PVector.sub(p, a);
  PVector ab = PVector.sub(b, a);
  ab.normalize(); // Normalize the line
  ab.mult(ap.dot(ab));
  PVector normalPoint = PVector.add(a, ab);
  return normalPoint;
}