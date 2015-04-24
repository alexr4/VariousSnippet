
//==========================================================
// modul: SurfacesMesh.pde - by Gerd Platl
//
// handle surface mesh texture, resolution, drawing & morphing 
//
// v0.1  2013-04-08  start working
// v0.2  2013-06-26  added morphing
// v1.0  2013-08-22  first release
//
// Implementation of class PSurfaceMesh:
// -------------------------------------
//   PSurfMesh (fi)         constructor
//   i = index              current surface index
//   s = name               current surface name
//   s = info               current information text 
//   select (fi)            select surface by function index
//   change (di)            select surface by delta index
//   setLimits (...)        set surface limits
//   setColor (color)       set surface color
//   setTexturMode(tm)      set surface texturing mode
//   setTexture (name)      load texture file and use surface texture
//   setResolution (u,v)    set surface resolution
//   setDrawMode (dm)       set current draw mode
//   calculateMeshPoints()  calculate all points
//   draw()                 draw surface mesh
//   morph(m1,m2,f)         transform mesh1 to mesh2
//
//==========================================================

class PSurfaceMesh
{
  PImage texPic, currentTexture;
  String textureName;
  
  int coloringCount = 7; 
  int coloringMode = 3;
  color surfaceColor;
  
//  int drawMode = QUAD_STRIP;
  int drawMode = TRIANGLES;
  int defaultResolution = 128;
  
  float uMin = -PI;
  float uMax = PI;
  int uCount = defaultResolution;

  float vMin = -PI;
  float vMax = PI;
  int vCount = defaultResolution;

  private PVector[][] points;     // surface edge points

  private ParametricSurface paramSurface;   
  
  //----------------------------------------------
  // constructor: select surface by function index
  //----------------------------------------------
  PSurfaceMesh (int functionIndex) 
  {
    surfaceColor = color(215,147,10);
    paramSurface = new ParametricSurface(functionIndex);
    calculateMeshPoints();
  }
  
  //--- get current surface index ---
  int index() { return paramSurface.index; }
  
  //--- get current surface name ---
  String name() { return paramSurface.name; }
  
  //--- get info text ---
  String info() { return paramSurface.info; }
  
  //--- select surface by function index ---
  void select (int functionIndex) 
  {
    // println (" select ("+functionIndex+");");
    paramSurface.SelectFunction(functionIndex);
    calculateMeshPoints();
  }
  
  //--- select surface by delta index ---
  void change (int deltaIndex) 
  {
    paramSurface.ChangeFunction (deltaIndex);
    calculateMeshPoints();
  } 

  //--- set surface limits ---
  void setLimits (float u_Min, float u_Max, float v_Min, float v_Max) 
  {
    uMin = u_Min;
    uMax = u_Max;
    vMin = v_Min;
    vMax = v_Max;
    calculateMeshPoints();
  }
  
  //--- set surface color ---
  void setColor (color surfaceColor) 
  {
    this.surfaceColor = surfaceColor;
    clearImage (currentTexture, surfaceColor); 
  }
  
  //--- set surface texture mode ---
  void setTexturMode(int coloring)
  {
    coloringMode = coloring % coloringCount;
    println (" coloringMode=" + coloringMode);
    doColoring();
  }
  //--- change surface texture mode ---
  void changeTextureMode(int delta)
  {
    setTexturMode ((coloringMode + delta) % coloringCount);
  }
  //--- prepare surface texture ---
  void doColoring()
  {
    switch (coloringMode)
    {        case 0:   // one color only
             case 1:   // one color and grid
        setColor(surfaceColor);
      break; case 2:   // RGB colors
             case 3:   // RGB colors and grid
        HSVImageX (currentTexture);
      break; case 4:   // RGB colors
             case 5:   // RGB colors and grid
        HSVImageY (currentTexture);
      break; case 6:   // texture  
        setTexture (textureImage);
    }    
    if ((coloringMode %2) == 1)
      drawGrid(currentTexture, 8, 8, color(0));
    setTexture (currentTexture);
  }
  
  //--- load texture file and use surface texture ---
  void setTexture (PImage img) 
  {
    //print("setTexture: ");
    texPic = img;
    currentTexture = createImage(uCount, vCount, RGB);
    // transform texture 
    currentTexture.copy (texPic, 0,0, texPic.width, texPic.height
                               , 0,0, uCount, vCount);
    println(texPic.width +"*" +texPic.height 
        + "  ===>  " +currentTexture.width  +"*" +currentTexture.height);
  }
  
  //--- load texture file and use surface texture ---
  void setTexture (String texturefilename) 
  {
    print("setTexture: " + texturefilename +"   " );
    if (texturefilename != "")
    {
      try 
      {
        texPic = loadImage(texturefilename);
      }
      catch (Exception e) 
      { texPic = new PImage(); }
      finally {}
    }
    
    if (texPic.width > 0)       // texture loaded ?
    {
      textureName = texturefilename;
      currentTexture = createImage(uCount, vCount, RGB);
      // transform texture 
      currentTexture.copy (texPic, 0,0, texPic.width, texPic.height
                                  ,0,0, uCount, vCount);
      println(texPic.width +"*" +texPic.height 
        + "  ===>  " +currentTexture.width  +"*" +currentTexture.height);
    }
  }
  
  //--- set surface resolution ---
  void setResolution (int u_Count, int v_Count) 
  {
    uCount = u_Count;
    vCount = v_Count;
    if (coloringMode < 6)   // reize current image ?
      currentTexture = createImage(uCount, vCount, RGB);
    doColoring();
  //  setTexture("");          // change current texture size
    calculateMeshPoints();
  } 
  
  //--- set current draw mode ---
  void setDrawMode(int newMode)
  {
    drawMode = newMode;
  }

  //--- calculate all points ---
  void calculateMeshPoints() 
  {
    points = new PVector[vCount+1][uCount+1];
    float u, v;
    for (int vi = 0; vi <= vCount; vi++)
    {
      v = map(vi, 0, vCount, vMin, vMax);
      for (int ui = 0; ui <= uCount; ui++)
      {
        u = map(ui, 0, uCount, uMin, uMax);
        points[vi][ui] = paramSurface.getValue(u, v);
      }
    }
  }

  //--- draw surface mesh ---
  void draw() 
  {
    fill(surfaceColor);
    int offset = 0;
    for (int v1 = 0; v1 < vCount; v1++) 
    {
      int v2 = v1+1;
      if (drawMode == TRIANGLES) 
      {
        for (int u1 = 0; u1 < uCount; u1++) 
        {
          int u2 = u1+1;
          beginShape(TRIANGLE_STRIP);
          fill(currentTexture.pixels[offset++]);
          vertex(points[v1][u2].x, points[v1][u2].y, points[v1][u2].z);
          vertex(points[v1][u1].x, points[v1][u1].y, points[v1][u1].z);
          vertex(points[v2][u2].x, points[v2][u2].y, points[v2][u2].z);
          vertex(points[v2][u1].x, points[v2][u1].y, points[v2][u1].z);
          endShape();
        }
      }
      else
      {
        // draw triangle strips
        beginShape(QUAD_STRIP);
        for (int u1 = 0; u1 < uCount; u1++) 
        {
          fill(currentTexture.pixels[offset++]);
          vertex(points[v2][u1].x, points[v2][u1].y, points[v2][u1].z);
          vertex(points[v1][u1].x, points[v1][u1].y, points[v1][u1].z);
        } 
        endShape();
      }
    }
  }
  
  //--- transform mesh1 to mesh2 ---
  //  factor   0.0 .. 1.0
  void morph(PSurfaceMesh mesh1, PSurfaceMesh mesh2, float factor) 
  {
    PVector v1 = new PVector();
    PVector v2 = new PVector();
    PVector v3 = new PVector();
    for (int yi = 0; yi <= vCount; yi++) 
    {
      for (int xi = 0; xi <= uCount; xi++) 
      {
        v1 = mesh1.points[yi][xi];
        v2 = mesh2.points[yi][xi];
        v3.x = v1.x + (v2.x - v1.x) * factor; 
        v3.y = v1.y + (v2.y - v1.y) * factor; 
        v3.z = v1.z + (v2.z - v1.z) * factor; 
 //       if ((yi == 10) && (xi == 10))
 //         println (nf(v1.z,0,2) +"  " +nf(v2.z,0,2) +"  " + nf(v3.z,0,2)+ "  " 
 //                 +nf(factor,0,2) + "   " +         points[yi][xi]);
        points[yi][xi].x = v3.x;
        points[yi][xi].y = v3.y;
        points[yi][xi].z = v3.z;
      }
    }
  }

}  // end of class PSurfaceMesh


//=== common functions ===

//----------------------------------------------
//  paint image with color1
//----------------------------------------------
void clearImage (PImage img, color color1)
{
  int dim = img.width*img.height;
  img.loadPixels();
  for (int ni = 0; ni < dim; ni++) 
    img.pixels[ni] = color1; 
  img.updatePixels();
}
//------------------ ----------------------------
//  draw horizontal HSB colored rectangle to image1
//-----------------------------------------------
void HSVImageX(PImage image1)
{ 
  if (image1 == null) return;
  int pixelOffset = 0;
  int w = image1.width;
  image1.loadPixels(); // must call before using pixels[]
  pushStyle();
  colorMode(HSB, w);
  for(int y=0; y < image1.height; y++)
  { for(int x=0; x < w; x++)
      image1.pixels[pixelOffset++] = color(x, w, w);
  }
  image1.updatePixels();
  popStyle();
}
//------------------ ----------------------------
//  draw vertical HSB colored rectangle to image1
//-----------------------------------------------
void HSVImageY(PImage image1)
{ 
  if (image1 == null) return;
  image1.loadPixels();
  pushStyle();
  int h = image1.height;
  colorMode(HSB, h);
  for(int y=0; y < h; y++)
  { for(int x=0; x < image1.width; x++)
      image1.pixels[y*h+x] = color(y, h, h);
  }
  image1.updatePixels();
  popStyle();
}
//----------------------------------------------
void drawGrid(PImage image1, int xd, int yd, color lineColor)
{ 
  if (image1 == null) return;
  image1.loadPixels();
  int w = image1.width;
  int h = image1.height;
  for(int y=0; y < h; y+=yd)  
  { // line(0,y, w-1,y);     horizontal line
    int offset = y * w;
    for(int x=0; x < w;  x++) 
      image1.pixels[offset++] = lineColor;
  }
  for(int x=0; x < w;  x+=(xd))  
  { // line(x,0, x,h-1);     vertical line
    for(int y=0; y < h;  y++)
      image1.pixels[y*w+x] = lineColor;
  }
  image1.updatePixels();
}

