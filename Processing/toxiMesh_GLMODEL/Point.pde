class Pt
{
  Vec3D loc;
  int idX, idY;
  Grid parent;

  float n, noff;

  Pt(Grid parent_, Vec3D _loc, int idX_, int idY_)
  {
    loc = _loc;
    idX = idX_;
    idY = idY_;
    parent = parent_;

    //loc.z = random(5);

    println("cols "+idX+" row: "+idY+" : "+loc);
  }

  void run()
  {
    //display();
    drawConnection();
  }

  void drawConnection()
  {
    if (idX < parent.cols-1 && idY < parent.rows-1)// && loc.z > 5) add this to use with kinect
    {
      Vec3D origine = parent.allPts[idX][idY].loc = loc;
      Vec3D neiRight = parent.allPts[idX+1][idY].loc;
      Vec3D neiDown = parent.allPts[idX][idY+1].loc;
      Vec3D neiDiag = parent.allPts[idX+1][idY+1].loc;

      Vec3D n1 = neiDown.sub(origine).cross(neiRight.sub(origine));
      Vec3D n2 = neiDiag.sub(neiDown).cross(neiRight.sub(neiDiag));

      n1 = n1.normalize();
      n2 = n2.normalize();
      

      mesh.addFace(loc, neiRight, neiDiag, n1);
      mesh.addFace(neiDiag, neiDown, loc, n2);
    }
  }

  void display()
  {
    stroke(0, 255, 0);
    strokeWeight(2);
    noFill();
    point(loc.x, loc.y, loc.z);
  }
}

