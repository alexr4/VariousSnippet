void getMethodeCamera(String name_, String type_)
  {
    Class camClass = CameraObject.class;

    if (type_ == "get")
    {
      try
      {
        Method m = camClass.getMethod(name_, null);
        println("Public method found on "+camClass+" : " +m.toString());
        try {
          println("\t"+camClass+"."+m.toString()+" = "+m.invoke(cam));
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
        println("Method either doesn't exist "+"or is not public: " + ex.toString()+cam);
      }
    }
    else if (type_ == "set")
    {
      try
      {
        Class[] args1 = new Class[1];
        args1[0] = float.class;
        Method m = camClass.getMethod(name_, args1);
        println("Public method found: on "+camClass+" : " +m.toString());
        try {
          // println("\t"+camClass+"."+m.toString()+" = "+m.invoke(cam, 1.0));
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

  void getMethodeCamera(String name_)
  {
    Class camClass = CameraObject.class;

    try
    {
      Method m = camClass.getMethod(name_, null);
      println("Public method found on "+camClass+" : " +m.toString());
      try {
        println("\t"+camClass+"."+m.toString()+" = "+m.invoke(cam));
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
      println("Method either doesn't exist "+"or is not public: " + ex.toString()+cam);
    }
  }

  void setMethodeCamera(String name_, float number_)
  {
    Class camClass = CameraObject.class;

    try
    {
      Class[] args1 = new Class[1];
      args1[0] = float.class;
      Method m = camClass.getMethod(name_, args1);
      println("Public method found: on "+camClass+" : " +m.toString());
      try {
        m.invoke(cam, 1.0);
        // println("\t"+camClass+"."+m.toString()+" = "+m.invoke(cam, 1.0));
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
