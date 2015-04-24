
//==========================================================
// modul: ParametricSurfaces.pde - by Gerd Platl
//
// Implements class ParametricSurface:  P(x,y,z) = f(u,v)                   
// with many examples of parametric surface functions.
//
// v0.1  2013-04-08  start working
// v1.0  2013-08-22  first release
//
// How to add a new surface function: 
// - note: replace <XXX> to new surface name
// - add 'new <XXX>Value(),' to 'functions' list
// - create class <XXX>Value as copy of function 'XxxValue' 
// - implement function <XXX>Value
// - use PVector.mult(pos, <scaleFactor>);  for scaling 
//
// More Surfaces...
//  http://www.3d-meier.de/tut3/Seite0.html
//  http://paulbourke.net/geometry
//==========================================================

int startPSurface = 5;    // sketch starting index of surface

float R=1.0, r=1.0, a=1.0, b=1.0, c=1.0, d=1.0, e=1.0, f=1.0;

//----------------------------------------------------------
// function definition: calculate value at given 3d position 
//----------------------------------------------------------
interface PSurfaceFunction 
{ 
  void init();
  String getName();    
  String getInfo();
  PVector getValue (float u, float v);  // P(x,y,z) = f(u,v)  
}

//----------------------------------------------------------
// set list of all surface functions 
//----------------------------------------------------------
PSurfaceFunction[] functions = new PSurfaceFunction[]
{ 
  new PlaneValue(),
  new TubeValue(),
  new SphereValue(),
  new EllipsoidValue(),
  new AstroidalEllipsoidValue(),
  new TorusValue(),
  new EllipticTorusValue(),
  new LimpetTorusValue(),
  new UmbilicTorusValue(),
  new Figure8TorusValue(),
  new SteinerSurfaceValue(),   // 10
  new BoySurfaceValue(),
  new ParaboloidValue(),
  new SineValue(),         
  new BohemianDomeValue(),
  new CorkscrewValue(),       
  new BowCurveValue(),
  new MaedersOwlValue(),
  new MultiOwlValue(),
  new TriaxialTritorusValue(),
  new HornValue(),            // 20
  new ShellValue(),
  new KidneyValue(),
  new LemniscapeValue(),  
  new SteinbachScrewValue(),
  new TranguloidTrefoilValue(),   
  new BentHornsValue(),
  new DinisFlowerValue(),
  new Helix2Value(),
  new TrefoilKnot3Value(),
  new TrefoilKnot5Value(),    // 30
  new CinquefoilKnotValue(),
  new TwistedCoilValue(),
  new MoebiusStrip(),
  new PisotTriaxialValue(),
  new SuperformulaValue(),
};

int pSurfaces = functions.length;     // number of surfaces

//---------------------------------------------------------
// print list of all parametric surfaces
//---------------------------------------------------------
void printParametricSurfaceList()
{
  for (int ni=0; ni<pSurfaces; ni++)
    println (ni + ":  " + functions[ni].getName()); 
}

//---------------------------------------------------------
// return index of existing surface
//---------------------------------------------------------
int realSurfaceIndex (int index)
{
   return ((index + pSurfaces) % pSurfaces);  
}

//==========================================================
// define class PSurface to handle current surfaces
//==========================================================
class ParametricSurface
{
  int index;               // current function index 
  String name;             // surface name
  String info;             // additional surface information
  PSurfaceFunction sFunc;  // current surface function

  // constructor: set surface function by index
  ParametricSurface (int functionIndex) 
  { 
    SelectFunction (functionIndex);
  }

  // select surface function by index
  void SelectFunction(int functionIndex) 
  { 
    this.index = (functionIndex + pSurfaces) % pSurfaces;
    functions[index].init();
    this.name = functions[index].getName();
    this.info = functions[index].getInfo();
    this.sFunc = functions[index];   // set function call
    println (index + ": " + name);
  }

  // select surface function by index
  void ChangeFunction(int deltaIndex) 
  {
    SelectFunction (index + deltaIndex);
  }
  
  // get algebraic surface value at position(u,v)
  PVector getValue(float u, float v)
  { //println ("Position: " +  sFunc.getValue(u,v));
    return sFunc.getValue (u, v);
  }
}


//==========================================================
// implementation of algebraic surface functions
//==========================================================

float[] params = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };

//---------------------------------------------------------
// Plane:  P = f(u,v,0)
//---------------------------------------------------------
class PlaneValue implements PSurfaceFunction 
{ 
  void init() {};
  String getName() { return "Plane"; }
  String getInfo() { return "x=u, y=0, z=v"; }
  PVector getValue(float u, float v)
  {
    return new PVector(u, 0, v);
  }
}

//----------------------------------------------------------
// Tube:  (cylinder)   R=radius a=height
//----------------------------------------------------------
class TubeValue implements PSurfaceFunction
{ 
  void init() { R=1.4; a=0.8; };
  String getName() { return "Tube"; }
  String getInfo() { return " x=R*sin(u)\n y=R*cos(u)\n z=h*v"; }
  PVector getValue(float u, float v)
  { 
    return new PVector (R*sin(u)
                       ,R*cos(u)
                       ,a*v);
  } 
}
//----------------------------------------------------------
// Sphere:                                          R=radius
//----------------------------------------------------------
class SphereValue implements PSurfaceFunction
{ 
  void init() { R=3.0; };
  String getName() { return "Sphere"; }
  String getInfo() { return " x=sin(v)*sin(u)\n y=sin(v)*cos(u)\n z=cos(v)"; }
  PVector getValue(float u, float v)
  { 
    //println (nf(u,0,2) + " " + nf(v,0,2));
    float w = (PI-v)/2; 
    return new PVector (R * sin(w) * sin(u)
                       ,R * sin(w) * cos(u)
                       ,R * cos(w));
  }
}
//----------------------------------------------------------
// Ellipsoid: 
//   x = a * sin(v) * sin(u)
//   y = b * sin(v) * cos(u)
//   z = c * cos(v)
//       0 <= u <= 2*Pi,   -Pi/2 <= v <= Pi/2
//---------------------------------------------------------
class EllipsoidValue implements PSurfaceFunction
{ 
  void init() { a=3.0; b=1.0; c=0.3; };
  String getName() { return "Ellipsoid"; }
  String getInfo() { return " x=a*sin(v)*sin(u)\n"
                          + " y=b*sin(v)*cos(u)\n"
                          + " z=c*cos(v)"; }
  PVector getValue(float u, float v)
  { 
    float f1 = sin((PI-v)/2);
    return new PVector (a * f1 * sin(u)
                       ,b * f1 * cos(u)
                       ,c * cos((PI-v)/2));
  }
}
//----------------------------------------------------------
class AstroidalEllipsoidValue implements PSurfaceFunction
{ 
  void init() { r=3.0; a=3.0; };
  String getName() { return "AstroidalEllipsoid"; }
  String getInfo() { return " x=(cos(u/2)*cos(v))^3\n"
                          + " y=(sin(u/2)*cos(v))^3\n"
                          + " z=(sin(v))^3"; }
  PVector getValue(float u, float v)
  { 
    u /= 2;
    float x = power(cos(u)*cos(v), a);
    float y = power(sin(u)*cos(v), a);
    float z = power(       sin(v), a);
    return new PVector(r*x, r*y, r*z);
  }
}

//----------------------------------------------------------
//  Torus       R = main radius,   r = ring radius
//----------------------------------------------------------
class TorusValue implements PSurfaceFunction
{ 
  void init() { R=2.0; r=0.5; };
  String getName() { return "Torus"; }
  String getInfo() { return " x=(R+r*cos(v)*sin(u))\n"
                          + " y=(R+r*cos(v))*cos(u)\n"
                          + " z=   r*sin(v)"; }
  PVector getValue(float u, float v)
  { 
    float x = (R + r * cos(v)) * sin(u);
    float y = (R + r * cos(v)) * cos(u);
    float z =      r * sin(v);
    return new PVector(x, y, z);
  }
}
//----------------------------------------------------------
class EllipticTorusValue implements PSurfaceFunction
{ 
  void init() { a=1.8; };
  String getName() { return "EllipticTorus"; }
  String getInfo() { return " x=(a+cos(v))*sin(u)\n"
                          + " y=(a+cos(v))*cos(u)\n"
                          + " z=sin(v)+cos(v)"; }
  PVector getValue(float u, float v)
  { 
    float x = (a + cos(v)) * sin(u);
    float y = (a + cos(v)) * cos(u);
    float z = sin(v) + cos(v);
    return new PVector(x, y, z);
  }
}
//----------------------------------------------------------
// Limpet Torus
//----------------------------------------------------------
class LimpetTorusValue implements PSurfaceFunction
{ 
  void init() { r=1.2;  a=1.0; };
  String getName() { return "LimpetTorus"; }
  String getInfo() { return " x=b*sin(u),     b=1/(sqrt(2)+sin(v))\n"
                          + " y=b*cos(u)\n"
                          + " z=1/sqrt(2)+cos(v))-1"; }
  PVector getValue(float u, float v)
  {
    b = a / (sqrt(2) + sin(v));
    float x = b * sin(u);
    float y = b * cos(u);
    float z = 1 / (sqrt(2) + cos(v)) - 1;
    return new PVector(r*x, r*y, r*z);    
  }
}
//----------------------------------------------------------
// UmbilicTorus
//   b = 7 + cos(u/3 - 2 * v) + 2 * cos(u/3 + v)
//   x = b * sin(u)
//   y = b * cos(u)
//   z = sin(u/3 - 2 * v) + 2 * sin(u/3 + v)
// http://www.3d-meier.de/tut3/Seite61.html
// http://en.goldenmap.com/Umbilic_torus
//----------------------------------------------------------
class UmbilicTorusValue implements PSurfaceFunction
{ 
  void init() { r=0.3; };
  String getName() { return "Umbilic Torus"; }
  String getInfo() { return " x=sin(u)*(7+cos(u/3-2*v)+2*cos(u/3+v))\n"
                          + " y=cos(u)*(7+cos(u/3-2*v)+2*cos(u/3+v))\n"
                          + " z=sin(u/3-2*v)+2*sin(u/3+v)"; }
  PVector getValue(float u, float v)
  { 
    float c = 7 + cos(u/3 - 2 * v) + 2 * cos(u/3 + v);
    float x = sin(u) * c;
    float y = cos(u) * c;
    float z = sin(u/3 - 2 * v) + 2 * sin(u/3 + v);
    return new PVector(r*x, r*y, r*z);
  }
}
//----------------------------------------------------------
class Figure8TorusValue implements PSurfaceFunction
{ 
  void init() { R = 1.5;  b=1.0; };
  String getName() { return "Figure8Torus"; }
  String getInfo() { return " x=a*sin(u)*(b+sin(v)*cos(u)-sin(2*v)*sin(u)/2)\n"
                          + " y=a*cos(u)*(b+sin(v)*cos(u)-sin(2*v)*sin(u)/2)\n"
                          + " z=a*sin(u)*sin(v)+cos(u)*sin(2*v)/2"; }
  PVector getValue(float u, float v)
  { 
    c = (b + sin(v) * cos(u) - sin(2*v) * sin(u) / 2);
    float y = a * cos(u) * c;
    float x = a * sin(u) * c;
    float z = a * sin(u) * sin(v) + cos(u) * sin(2*v) / 2;
    return new PVector(x, y, z);
  }
}
//----------------------------------------------------------
// Steiner Surface  (also known as Roman surface)
//   x = cos(v) cos(v) sin(2u) / 2
//   y = sin(u) sin(2v) / 2
//   z = cos(u) sin(2v) / 2
//       0 <= u <= Pi,   0 <= v <= Pi
// http://paulbourke.net/geometry/steiner/
// http://en.wikipedia.org/wiki/Roman_surface
//----------------------------------------------------------
class SteinerSurfaceValue implements PSurfaceFunction
{ 
  void init() { r=2.8; };
  String getName() { return "Steiner Surface"; }
  String getInfo() { return " x=cos(v)^2*sin(2*u)\n"
                          + " y=sin(u)*sin(2*v)\n"
                          + " z=cos(u)*sin(2*v)"; }
  PVector getValue(float u, float v)
  { 
    u *= 0.5;
    v *= 0.5;
    float sin2v = sin(2*v);
    float x = sq(cos(v)) * sin(2*u);
    float y = sin(u) * sin2v;
    float z = cos(u) * sin2v; 
    return new PVector(r*x, r*y, r*z);
  }
}
//----------------------------------------------------------
// Boy Surface
//   x = f1 * (cos(2*u) + f2) / f3      f1 = Sqrt2 * sqr(cos(v))
//   y = f1 * (sin(2*u) + f2) / f3      f2 = cos(u) * sin(2*v)
//   z =     3 * sqr (cos(v)) / f3      f3 = 2 - Sqrt2 * sin(3*u) * sin (2*v)
//       0 <= u <= 2*Pi     0 <= v <= Pi / 2
// http://www.3d-meier.de/tut3/Seite6.html
// http://mathworld.wolfram.com/BoySurface.html
// http://paulbourke.net/geometry/boy/
//----------------------------------------------------------
class BoySurfaceValue implements PSurfaceFunction
{ 
  void init() { r=2.0;  a = 2.0 / 3.0;  b = sqrt(2); };
  String getName() { return "Boy Surface"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  { 
    u += (u + PI) * 0.5;
    v *= 0.5;
    float f1 = 1;
    float f2 = 1;
    float f3 = b - sin(2*u)*sin(3*v);
    float x = a*(cos(u)*cos(2*v) + b*sin(u)*cos(v))*cos(u) / f3;
    float y = a*(cos(u)*sin(2*v) - b*sin(u)*sin(v))*cos(u) / f3;
    float z = b*cos(u)*cos(u) / (b -sin(2*u)*sin(3*v));
    return new PVector(r*x, r*y, r*z);
  }
}
//----------------------------------------------------------
class ParaboloidValue implements PSurfaceFunction
{ 
  void init() { d=1.0; };
  String getName() { return "Paraboloid"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  { 
    float x = power((v/d),0.5) * sin(u);
    float y = power((v/d),0.5) * cos(u);
    float z = v;
    return new PVector(x, y, z);
  }
}
//----------------------------------------------------------
class SineValue implements PSurfaceFunction
{ 
  void init() { a=1.0; };
  String getName() { return "Sine"; }
  String getInfo() { return " x=sin(u), y=sin(a*v), z=sin(u+v)"; }
  PVector getValue(float u, float v)
  { 
    float x = sin(u);
    float y = sin(a * v);
    float z = sin(u+v);
    return new PVector(2.0*x, 2.0*y, 2.0*z);
  }
}
//----------------------------------------------------------
class BohemianDomeValue implements PSurfaceFunction
{ 
  void init() { r=2.0; };
  String getName() { return "BohemianDome"; }
  String getInfo() { return " x=cos(u), y=sin(v), z=sin(u)+cos(v)"; }
  PVector getValue(float u, float v)
  { 
    float x = r * cos(u);
    float y = r * sin(v);
    float z = r * sin(u) + cos(v);
    return new PVector(x, y, z);
  }
}
//----------------------------------------------------------
class CorkscrewValue implements PSurfaceFunction
{ 
  void init() { r=1.2;  a=0.6; };
  String getName() { return "Corkscrew"; }
  String getInfo() { return " x=cos(u)*cos(v), y=sin(u)*cos(v), z=sin(v)+a*u"; }
  PVector getValue(float u, float v)
  { 
    float x = cos(u) * cos(v);
    float y = sin(u) * cos(v);
    float z = sin(v) + a * u;
    return new PVector(r*x, r*y, r*z);
  }
}
//----------------------------------------------------------
// http://paulbourke.net/geometry/bow/
//----------------------------------------------------------
class BowCurveValue implements PSurfaceFunction  // r=pipe radius
{ 
  void init() { R=0.7; r=0.65; };
  String getName() { return "Bow Curve"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  { 
    float x = R * (2 + r * sin(u)) * sin(2 * v);
    float y = R * (2 + r * sin(u)) * cos(2 * v);
    float z = R * (    r * cos(u) + 3 * cos(v));
    return new PVector(x, y, z);
  }
}
//----------------------------------------------------------
// Maeder's Owl        (Bour's Minimal Surface)
//   x =  v * cos(u) - v^2 / 2 * cos(2 * u)
//   y = -v * sin(u) - v^2 / 2 * sin(2 * u)
//   z = 4 / 3 * v^1.5 * cos(1.5 * u)
//       0 <= u <= 4*Pi,   0 <= v <= 1
// http://www.3d-meier.de/tut3/Seite35.html
// http://paulbourke.net/geometry/owl/
// http://mathworld.wolfram.com/BoursMinimalSurface.html
// http://www.math.hmc.edu/~gu/curves_and_surfaces/surfaces/bour.html
//----------------------------------------------------------
class MaedersOwlValue implements PSurfaceFunction
{ 
  void init() {  r=2.2;  a=1.0;  };
  String getName() { return "Maeders_Owl"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  {
    u = 2*(u+PI);        // 0 .. 4*PI
    v = 0.5*(v + PI) / PI;   // 0.0 .. 1.0
    float f1 = 0.5 * a * v*v;
    float x =  v * cos(u) - f1 * cos(2 * u);
    float y = -v * sin(u) - f1 * sin(2 * u);
    float z = 4 / 3 * power(v, 1.5) * cos(1.5 * u);
    return new PVector(r*x, r*y, r*z);
  }
}
//*********************************************************
// MultiOwl          (a=3 -> Maeder's Owl)
//   a = ...-7|-5|-3|-1|1|3|5|7|...
//   b = a - 1
//   x =  v*cos(u) - cos(b * u) * v^2 / b
//   y = -v*sin(u) - sin(b * u) * v^2 / b
//   z = v^1.5 * cos(a * u / 2)
//       0 <= u <= 4*Pi,   0 <= v <= 1
//----------------------------------------------------------
class MultiOwlValue implements PSurfaceFunction
{ 
  void init() {  r=2.2;  a=7.0;  };
  String getName() { return "Multi_Owl"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  {
    u = 2*(u+PI);        // 0 .. 4*PI
    v = 0.5*(v + PI) / PI;   // 0.0 .. 1.0
    b = a -1.0;  
    c = v*v / b;
    float x =  v * cos(u) - c * cos(b * u);
    float y = -v * sin(u) - c * sin(b * u);
    float z = 0.66 * power(v, 1.5) * cos(a * u * 0.5);
    return new PVector(r*x, r*y, r*z);
  }
}
//---------------------------------------------------------
class TriaxialTritorusValue implements PSurfaceFunction
{ 
  void init() { r=1.5; a=3.0; };
  String getName() { return "TriaxialTritorus"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  { 
    b = TWO_PI / a;
    c = 2*b;
    float x = sin(u) * (1 + cos(v));
    float y = sin(u + b) * (1 + cos(v + b));
    float z = sin(u + c) * (1 + cos(v + c));
    return new PVector(r*x, r*y, r*z);
  }
}
//----------------------------------------------------------
class HornValue implements PSurfaceFunction
{ 
  void init() { a = 2.0; };
  String getName() { return "Horn"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  { 
    u = 0.5*(u+PI)/PI;
    float x = (a + u * cos(v)) * sin(TWO_PI * u);
    float z = (a + u * cos(v)) * cos(TWO_PI * u) + 1.5 * u;
    float y = u * sin(v);
    return new PVector(x, y, z);
  }
}
//----------------------------------------------------------
class ShellValue implements PSurfaceFunction
{ 
  void init() { r=0.5;  a = 1.2;  b = 1.5;  c = 1.0; }
  String getName() { return "Shell"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  { u *= 2.0;
    d = u / TWO_PI;
    float cosU = cos(a*u);
    float sinU = sin(a*u);
    float x = b * (1 - d) * cosU * (1 + cos(v)) + c * cosU;
    float y = b * (1 - d) * sinU * (1 + cos(v)) + c * sinU;
    float z = 2*(b * d + a * (1 - d) * sin(v));
    return new PVector(r*x, r*y, r*z);
  }
}
//----------------------------------------------------------
class KidneyValue implements PSurfaceFunction
{ 
  void init() { r=0.7; a=3.0; };
  String getName() { return "Kidney"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  { 
    u /= 2;
    float x = cos(u) * (a*cos(v) - cos(3*v));
    float y = sin(u) * (a*cos(v) - cos(3*v));
    float z =         3 * sin(v) - sin(3*v);
    return new PVector(r*x, r*y, r*z);
  }
}
//----------------------------------------------------------
class LemniscapeValue implements PSurfaceFunction
{ 
  void init() { r=3.0;  a=2.0; };
  String getName() { return "Lemniscape"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  { 
    u /= 2;
    v = (v+PI) * 0.5;
    float k = cos(v)*sqrt(abs(sin(a*u)));
    float x = k*cos(u);
    float y = k*sin(u);
    float z = power(x, 2) - power(y, 2) + 2 * x * y * power(tan(v), 2);
    return new PVector(r*x, r*y, r*z);
  }
}
//----------------------------------------------------------
class SteinbachScrewValue implements PSurfaceFunction
{ 
  void init() { r=0.7; };
  String getName() { return "SteinbachScrew"; }
  String getInfo() { return "u*cos(v),  v*cos(u),  u*sin(v)"; }
  PVector getValue(float u, float v)
  { 
    float x = r * u * cos(v);
    float y = r * v * cos(u);
    float z = r * u * sin(v);
    return new PVector(x, y, z);
  }
}
//----------------------------------------------------------
// Tranguloid Trefoil
// http://paulbourke.net/geometry/tranguloid/
// http://www.scientificlib.com/en/Mathematics/Surfaces/TranguloidTrefoil.html
//----------------------------------------------------------
class TranguloidTrefoilValue implements PSurfaceFunction
{ 
  void init() { r=0.75; a = 2.0; };
  String getName() { return "Trianguloid Trefoil"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  { 
    float x = sin(3*u) * 2 / (2 + cos(v));
    float y = (sin(u) + a * sin(2*u)) * 2 / (2 + cos(v + TWO_PI));
    float z = (cos(u) - a * cos(2*u)) * (2 + cos(v)) * ((2 + cos(v + TWO_PI/3))*0.25);
    return new PVector(r*x, r*y, r*z);
  }
}
//----------------------------------------------------------
class BentHornsValue implements PSurfaceFunction
{ 
  void init() { r=0.5; };
  String getName() { return "Bent Horns"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  { 
    v *= 2;
    float x = (2 + cos(u))          * (v/3 - sin(v));
    float y = (2 + cos(u - 2*PI/3)) * (cos(v)-1);
    float z = -(2 + cos(u + 2*PI/3)) * (cos(v)-1);
    return new PVector (r*x, r*y, r*z);
  }
}
//----------------------------------------------------------
class DinisFlowerValue implements PSurfaceFunction
{ 
  void init() {};
  String getName() { return "Dinis Flower"; }
  String getInfo() { return "cos(u)*sin(v), sin(u)*sin(v), cos(v)+log(tan((v/2)))+0.2*u"; }
  PVector getValue(float u, float v)
  { 
    u = (u+PI)*3;
    v = (v+PI)/3;
    float x = cos(u) * sin(v);
    float y = sin(u) * sin(v);
    float z = cos(v) + log(tan((v/2))) +0.2*u;
    return new PVector(x, y, z);
  }
}
//----------------------------------------------------------
// Helix2 Surface
//   f1 = R + r * cos(v)               w = sqrt(R^2 +r^2)
//   f2 = r * h * sin(v) / w           h = helix rise 
//   x = f1 * cos(u) + f2 * sin(u)     a = windings
//   y = f1 * sin(u) - f2 * cos(u)     R = main radius
//   z = h * u + R * r * sin(v)/w      r = ring radius
//       0 <= u <= 2*Pi     0 <= v <= 2*Pi
// http://www.3d-meier.de/tut3/Seite83.html
//----------------------------------------------------------
class Helix2Value implements PSurfaceFunction
{ 
  void init() { R=2.0;  r=0.25;  a=4.0;  };
  String getName() { return "Helix2"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  { u *= a;
    float h = 0.8 / a;
    float w = sqrt(R*R+r*r);
    float f1 = R + r * cos(v);
    float f2 = r * h * sin(v) / w;
    float x = f1 * cos(u) + f2 * sin(u);
    float y = f1 * sin(u) - f2 * cos(u);
    float z = h*u + R*r*sin(v)/w;
    return new PVector(x, y, z);
  }
}
//----------------------------------------------------------
// Trefoil Knots
// http://mathworld.wolfram.com/TrefoilKnot.html
// http://paulbourke.net/geometry/knots/
// http://www.3d-meier.de/tut3/Seite56.html
//----------------------------------------------------------
class TrefoilKnot3Value implements PSurfaceFunction
{ 
  void init() 
  { R = 0.6;   // main radius
    r = 0.2;   // pipe radius
  };   
  String getName() { return "Trefoil Knot 3"; }
  String getInfo() { return " c=R*(4+cos(3*u))+r*cos(v)\n"
                          + " x=sin(2*u)*c\n"
                          + " y=cos(2*u)*c\n"
                          + " z=R*0.5*sin(3*u)+r*sin(v))"; }
  PVector getValue(float u, float v)
  { float c = R * (4 + cos(3*u)) + r * cos(v);
    return new PVector( sin(2*u) * c,
                        cos(2*u) * c,
                        R * 0.5 * sin(3*u) + r * sin(v));
  }
}
//----------------------------------------------------------
class TrefoilKnot5Value implements PSurfaceFunction
{ 
  void init() 
  { R = 0.6;   // main radius
    r = 0.2;   // pipe radius
  };   
  String getName() { return "Trefoil Knot 5"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  { float c = R * (4 + cos(5*u)) + r * cos(v);
    return new PVector( sin(3*u) * c,
                        cos(3*u) * c,
                        R * 1.5 * sin(5*u) + r * sin(v));
  }
}
//----------------------------------------------------------
// Cinquefoil Knot                    
//   x = cos(u) * c                   R: figure radius
//   y = sin(u) * c                   r: pipe radius
//   z = R - sin(b) + r * sin(v)    a: windings >= 0
//     b = 2 * u / (2*a + 1)
//     c = R * (2 - cos(b)) + r * cos(v)
//         0 <= u < (4*a + 2)*Pi     -Pi/2 <= v <= Pi/2
// http://paulbourke.net/geometry/knots/
//----------------------------------------------------------
class CinquefoilKnotValue implements PSurfaceFunction
{ 
  void init() 
  { R = 1.0;   // main radius
    r = 0.2;   // pipe radius
    a = 3.0;   // winding value >= 0
  };   
  String getName() { return "Cinquefoil Knot"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  { u *= (2*a+1);
    float b = 2*u / (2*a + 1.0);
    float c = R * (2 - cos(b)) + r * cos(v);
    return new PVector( cos(u) * c,
                        sin(u) * c,
                        R * sin(b) + r * sin(v));
  }
}
//----------------------------------------------------------
class TwistedCoilValue implements PSurfaceFunction
{ 
  void init() { r=0.5;  a=7.0; };
  String getName() { return "Twisted Coil"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  { 
    c = (a + 2*cos(5 * u) + cos(v));
    float x = c * cos(u);
    float y = c * sin(u);
    float z = sin(v) + 0.5*sin(7 * u);
    return new PVector(r*x, r*y, r*z);
  }
}
//----------------------------------------------------------
// Moebius Strip
//   x = cos(u) * (3 + v * cos(u/2))
//   y = sin(u) * (3 + v * cos(u/2))
//   z =               v * sin(u/2)
//       -Pi <= u <= Pi     -1 <= v <= +1
// http://paulbourke.net/geometry/mobius/
//----------------------------------------------------------
class MoebiusStrip implements PSurfaceFunction
{ 
  void init() { r=0.35; };
  String getName() { return "Moebius Strip"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  { 
    c = 6 + v * cos (0.5 * u);
    float x = cos(u) * c;
    float y = sin(u) * c;
    float z = v * sin(0.5 * u);
    return new PVector(r*x, r*y, r*z);
  }
}
//----------------------------------------------------------
// Pisot Triaxial
// http://paulbourke.net/geometry/mobius/
//----------------------------------------------------------
class PisotTriaxialValue implements PSurfaceFunction
{ 
  void init() { r=1.5; };
  String getName() { return "Pisot Triaxial"; }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  { 
    float x = 0.655866 * cos(1.03002 + u) * (2 + cos(v));
    float y = 0.754878 * cos(1.40772 - u) * (2 + 0.868837 * cos(2.43773 + v));
    float z = 0.868837 * cos(2.43773 + u) * (2 + 0.495098 * cos(0.377696 - v)); 
    return new PVector(r*x, r*y, r*z);
  }
}

//----------------------------------------------------------
class SuperformulaValue implements PSurfaceFunction
{ 
  void init() {};
  String getName() 
  { 
    if (params[0] == 1.0);
    { params[0] = random(0,2);
      params[1] = random(0,2);
      params[2] = random(0,2);
      params[3] = random(0,2);
      params[4] = random(0,2);
      params[5] = random(0,2);
      params[6] = random(0,2);
      params[7] = random(0,2);
      params[8] = random(0,2);
      params[9] = random(0,2);
      params[10] = random(0,2);
      params[11] = random(0,2);
    }
    return "Superformula"; 
  }
  String getInfo() { return ""; }
  PVector getValue(float u, float v)
  { 
    v /= 2;
    // Superformel 1
    float a = params[0];
    float b = params[1];
    float m = (params[2]);
    float n1 = (params[3]);
    float n2 = (params[4]);
    float n3 = (params[5]);
    float r1 = pow(pow(abs(cos(m*u/4)/a), n2) + pow(abs(sin(m*u/4)/b), n3), -1/n1);
    // Superformel 2
    a = params[6];
    b = params[7];
    m = (params[8]);
    n1 = (params[9]);
    n2 = (params[10]);
    n3 = (params[11]);
    float r2 = pow(pow(abs(cos(m*v/4)/a), n2) + pow(abs(sin(m*v/4)/b), n3), -1/n1);
    float x = r1*sin(u) * r2*cos(v);
    float y =             r2*sin(v);
    float z = r1*cos(u) * r2*cos(v);
    return new PVector(2.0*x, 2.0*y, 2.0*z);
  }
}

//====== definition of basic mathematical functions ========

//----------------------------------------------------------
// the processing-function pow works a bit differently for negative bases
//----------------------------------------------------------
float power(float b, float e) 
{
  if (b >= 0 || int(e) == e) 
       return pow(b, e);
  else return -pow(-b, e);
}
//----------------------------------------------------------
float logE(float v) 
{
  if (v >= 0) return log(v); 
  else        return -log(-v);
}
//----------------------------------------------------------
float sinh(float a) { return (sin(HALF_PI/2 - a)); }
//----------------------------------------------------------
float cosh(float a) { return (cos(HALF_PI/2 - a)); }
//----------------------------------------------------------
float tanh(float a) { return (tan(HALF_PI/2 - a)); }
//----------------------------------------------------------
float Sqrt2 = sqrt(2.0);


