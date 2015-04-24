class Grid
{
  int cols, rows;
  float resX, resY;

  Pt[][] allPts;

  float noff0, noff1, noff2, n0, n1, n2;


  Grid(int cols_, int rows_, float resX_, float resY_)
  {
    cols = cols_;
    rows = rows_;
    resX = resX_;
    resY = resY_;

    allPts = new Pt[cols][rows];

    for (int i=0; i<cols; i++)
    {
      noff0 = noise(n0);
      for (int j=0; j<rows; j++)
      {
        noff1 = noise(n1);

        float z = noise(i*noff0, j*noff1)*10;


        Vec3D v = new Vec3D(i*resX, j*resY, z);

        allPts[i][j] = new Pt(this, v, i, j);

        n1+=0.002;
      }
      n0 += 0.003;
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

