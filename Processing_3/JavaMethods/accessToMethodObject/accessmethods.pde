import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.util.Locale;
import static java.lang.System.out;
import static java.lang.System.err;

Class classObj = classExemple.class;

void getMethodeFromClass(String name_, String type_)
{
  
  if (type_ == "get")
  {
    try
    {
      Method m = classObj.getMethod(name_, null);
      println("Public method found on "+classObj+" : " +m.toString());
      try {
        println("\t"+classObj+"."+m.toString()+" = "+m.invoke(ce));
      } 
      catch (IllegalArgumentException e) {
      } 
      catch (IllegalAccessException e) {
      } 
      catch (InvocationTargetException e) {
      }
    }
    catch (NoSuchMethodException ex)
    {
      println("Method either doesn't exist "+"or is not public: " + ex.toString()+ce);
    }
  } else if (type_ == "set")
  {
    try
    {
      Class[] args1 = new Class[1];
      args1[0] = float.class;
      Method m = classObj.getMethod(name_, args1);
      println("Public method found: on "+classObj+" : " +m.toString());
      try {
         println("\t"+classObj+"."+m.toString()+" = "+m.invoke(ce, 1.0));
      } 
      catch (IllegalArgumentException e) {
      } 
      catch (IllegalAccessException e) {
      } 
      catch (InvocationTargetException e) {
      }
    }
    catch (NoSuchMethodException ex)
    {
      println("Method either doesn't exist " +"or is not public: " + ex.toString());
    }
  }
}

void getMethodeFromClass(String name_)
{
  try
  {
    Method m = classObj.getMethod(name_, null);
    println("Public method found on "+classObj+" : " +m.toString());
    try {
      println("\t"+classObj+"."+m.toString()+" = "+m.invoke(ce));
    } 
    catch (IllegalArgumentException e) {
    } 
    catch (IllegalAccessException e) {
    } 
    catch (InvocationTargetException e) {
    }
  }
  catch (NoSuchMethodException ex)
  {
    println("Method either doesn't exist "+"or is not public: " + ex.toString()+ce);
  }
}

void setMethodeFromClass(String name_, float number_)
{
  try
  {
    Class[] args1 = new Class[1];
    args1[0] = float.class;
    Method m = classObj.getMethod(name_, args1);
    println("Public method found: on "+classObj+" : " +m.toString());
    try {
      m.invoke(ce, number_);
      // println("\t"+camClass+"."+m.toString()+" = "+m.invoke(obj, 1.0));
    } 
    catch (IllegalArgumentException e) {
    } 
    catch (IllegalAccessException e) {
    } 
    catch (InvocationTargetException e) {
    }
  }
  catch (NoSuchMethodException ex)
  {
    println("Method either doesn't exist " +"or is not public: " + ex.toString());
  }
}