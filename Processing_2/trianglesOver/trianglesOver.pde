//mouse over triangle
int pWidth = 500;
int pHeight = 500;

//Triangles coordinates
ArrayList<PVector> aList;
ArrayList<PVector> bList;
ArrayList<PVector> cList;
int nbTriangles;

//Mouse coordinates
PVector m;


void setup() 
{
  size(pWidth, pHeight, P2D);
  smooth();

  //Triangles coordinates
  aList = new ArrayList<PVector>();
  bList = new ArrayList<PVector>();
  cList = new ArrayList<PVector>();

  nbTriangles = 50;

  for (int i=0; i<nbTriangles; i++)
  {
    float x0 = random(width);
    float x1 = random(x0-50, x0+50);
    float x2 = random(x0-50, x0+50);
    float y0 = random(height);
    float y1 = random(y0-50, y0+50);
    float y2 = random(y0-50, y0+50);

    PVector a = new PVector(x0, y0);
    PVector b = new PVector(x1, y1);
    PVector c = new PVector(x2, y2);

    aList.add(a);
    bList.add(b);
    cList.add(c);
  }
}

void draw() 
{
  background(128);

  //Mouse Coordinates
  m = new PVector(mouseX, mouseY);

  for (int i=0; i<nbTriangles; i++)
  {
    PVector a = aList.get(i);
    PVector b = bList.get(i);
    PVector c = cList.get(i);
    
    PointInTriangle(m, a, b, c);//Find over
    
    triangle(a.x, a.y, b.x, b.y, c.x, c.y); //draw triangles
  }
}

boolean SameSide(PVector p1, PVector p2, PVector a, PVector b) {

  //Définition des vecteur ab = b(to)a p1a = p1(to)a et p2a = p2(to)a
  PVector ab = PVector.sub(b, a);
  PVector p1a = PVector.sub(p1, a);
  PVector p2a = PVector.sub(p2, a);

  //Definition des vecteur up and down (perpendiculaire) à ab et p1a - ab et p2a
  PVector cp1 = ab.cross(p1a);
  PVector cp2 = ab.cross(p2a);

  //Définition du cosinus des deux perpendiculaires
  if ((cp1.dot(cp2)) >= 0) 
  {
    return true;
  } else
  {
    return false;
  }
}

boolean PointInTriangle(PVector m, PVector a, PVector b, PVector c) {
  if (SameSide(m, a, b, c) && SameSide(m, b, a, c) && SameSide(m, c, a, b)) {
    fill(255, 0, 0);
    return true;
  } else
    fill(255, 255, 255);
  return false;
}

