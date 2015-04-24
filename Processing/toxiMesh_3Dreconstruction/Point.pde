class Pt
{
  Vec3D loc;
  int idX, idY;
  sphereMesh parent;

  float n, nOff;

  Pt(sphereMesh parent_, Vec3D _loc, int idX_, int idY_)
  {
    loc = _loc;
    idX = idX_;
    idY = idY_;
    parent = parent_;

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

      // compute UV coords for all 4 vertices...
      Vec2D uva=new Vec2D(origine.x, origine.y).scaleSelf(scaleUV);
      Vec2D uvb=new Vec2D(neiRight.x, neiRight.y).scaleSelf(scaleUV);
      Vec2D uvc=new Vec2D(neiDiag.x, neiDiag.y).scaleSelf(scaleUV);
      Vec2D uvd=new Vec2D(neiDown.x, neiDown.y).scaleSelf(scaleUV);

      mesh.addFace(origine, neiRight, neiDown, uva, uvb, uvd);
      mesh.addFace(neiDown, neiRight, neiDiag, uvd, uvb, uvc);
    }
  }

  void display()
  {
    stroke(0, 255, 0);
    strokeWeight(1);
    noFill();
    point(loc.x, loc.y, loc.z);
  }
}
