class pointCoord
{
  PVector location;
  PVector origine;

  pointCoord(PVector location_)
  {
    location = location_.get();
    origine = location_.get();
  }

  void overDesign(PVector m, float vz, float limite)
  {
    float d = dist(mouseX, mouseY, location.x, location.y);
   
    if (d<=limite*2)
    {
      if (location.z >= limite)
      {
        location.z = limite;
      }
      else
      {
        location.z += vz;
      }
    }
    else
    {
      if (location.z <= origine.z)
      {
        location.z = origine.z;
      }
      else
      {
        location.z -= vz;
      }
    }
  }
  void drawVertex()
  {
    float r = 0;//map(location.z, 0, 50, 0, 255);
    float g = map(location.y, height/2-50, height/2+50, 100, 255);
    float b = map(location.x, 0, width, 160, 255);
    float a = map(location.z, 0, 50, 100, 200);
    

    //noFill();
    noStroke();
    fill(r, g, b,a);
    stroke(r,g,b);
    vertex(location.x, location.y, location.z);
  }
}

