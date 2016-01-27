classExemple ce;

void setup()
{
  size(500, 500, P2D);
  ce = new classExemple();
}

void draw()
{
  background(127);
  
  setMethodeFromClass("setFloatX", 2.0);
  getMethodeFromClass("getFloatX");
  //getMethodeFromClass("getFloatX", "get");
  //printClassName(ce);
}

void printClassName(Object obj) {
  System.out.println("The class of " + obj +
    " is " + obj.getClass().getName());
}