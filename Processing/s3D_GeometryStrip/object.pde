class ribbon
{
  ArrayList<face> f;
  ArrayList<PVector> vertices;
  ArrayList<PVector> center;
  
  int w, h;
  PVector location, a, b, c, d;




  ribbon(int nbFace, int largeur_, int hauteur_, PVector location_)
  {
    w = largeur_;
    h = hauteur_;
    location = location_.get();
  
    
    vertices = new ArrayList<PVector>();
    center = new ArrayList<PVector>();
    f = new ArrayList<face>();
    
    for (int v=0; v<4; v++)
    {
      vertices.add(new PVector(0, 0, 0)); //A
      vertices.add(new PVector(w, 0, 0)); //B
      vertices.add(new PVector(w, h, 0)); //D
      vertices.add(new PVector(0, h, 0)); //C
    }

    for (int i = 0; i<nbFace; i++)
    {
      f.add( new face(i));
      PVector centerVec = new PVector(location.x+(i*w)+w/2, location.y, location.z);
      center.add(centerVec);
      println(centerVec);
      for (int j = 0; j<vertices.size(); j+=4)
      {
         a = new PVector(location.x+(i*w), location.y-h/2, location.z);
        
        float x1 = vertices.get(j+1).x;
        float y1 = vertices.get(j+1).y;
        float z1 = vertices.get(j+1).z;
         b = new PVector(x1, y1, z1);
        b.add(a);

        float x2 = vertices.get(j+2).x;
        float y2 = vertices.get(j+2).y;
        float z2 = vertices.get(j+2).z;
         d = new PVector(x2, y2, z2);
        d.add(a);

        float x3 = vertices.get(j+3).x;
        float y3 = vertices.get(j+3).y;
        float z3 = vertices.get(j+3).z;
         c = new PVector(x3, y3, z3);
        c.add(a);

        
      }

       f.get(i).addPoint(a, b, c);
       f.get(i).addPoint(c, b, d);
    }
    println(center.size());
  }
  
  

  void draw3D()
  {
    PVector m = new PVector(mouseX, mouseY);
    float vz = 10.5;
    float limite = w/2;
    
    beginShape(TRIANGLES);
    for (face faces:f)
    {
      
      faces.drawConnection(m, vz, limite);
      
    }
    
    endShape(CLOSE);
  }

  
}

