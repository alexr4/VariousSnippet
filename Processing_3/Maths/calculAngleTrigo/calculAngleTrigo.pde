Float calulateAngle(PVector vertA, PVector vertB, int orientation)
{

  if (orientation == 1)
  { //X rotation
    float adjacant = vertB.x - vertA.x;
    float oppose = vertB.z - vertA.z;

    float phi = atan2(oppose, adjacant); 
    return phi;
  } else if (orientation == 2)
  {//Y rotation
    float adjacant = vertB.x - vertA.x;
    float oppose = vertB.y - vertA.y;
    float phi = atan2(oppose, adjacant); 
    return phi;
  } else if (orientation == 3)
  {//z Rotation
    float adjacant = vertB.y - vertA.y;
    float oppose = vertB.z - vertA.z;
    float phi = atan2(oppose, adjacant); 
    return phi;
  } else
  {
    return null;
  }
}