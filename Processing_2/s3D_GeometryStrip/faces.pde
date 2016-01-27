class face
{
  ArrayList<pointCoord> pts;
  int ptsArraySize;
  int indexFace;
  

  face(int indexFace_) {
    indexFace = indexFace_;
    pts = new ArrayList<pointCoord>();
  }

  void addPoint(PVector a, PVector b, PVector c)
  {
    pts.add(new pointCoord(a));
    pts.add(new pointCoord(b));
    pts.add(new pointCoord(c));
  }

  void drawConnection(PVector m, float vz, float limite)
  {
    for (pointCoord p: pts)
    {
      
      p.overDesign(m, vz, limite);
      p.drawVertex();
      
    }
  }
}

