class sphereMesh
{
  int cols, rows;
  float resX, resY;
  float r;

  Pt[][] allPts;


  sphereMesh(int cols_, int rows_, float resX_, float resY_)
  {
    cols = cols_;
    rows = rows_;
    resX = resX_;
    resY = resY_;
    r = 100;

    allPts = new Pt[cols][rows];

    for (int i=0; i<cols; i++)
    {
      for (int j=0; j<rows; j++)
      {
       float alpha = map(i, 0, cols-1, 0, 360);
       float beta = map(j, 0, rows-1, 0, 360);

       float x = cos(radians(alpha))*cos(radians(beta))*r;
       float y = cos(radians(alpha))*sin(radians(beta))*r;
       float z = sin(radians(alpha))*r;


        Vec3D v = new Vec3D(x, y, z);
        allPts[i][j] = new Pt(this, v, i, j);
      }
    }
  }

  void run()
  { 
    runPoints();
  }

  void runPoints()
  {
    for (int i=0; i<cols; i++)
    {
      for (int j=0; j<rows; j++)
      {
        allPts[i][j].run();
      }
    }
  }
}

