
PVector computeRodrigueRotation(PVector k, PVector v, float theta)
{
  // Olinde Rodrigues formula : Vrot = v* cos(theta) + (k x v) * sin(theta) + k * (k . v) * (1 - cos(theta));
  PVector kcrossv = k.cross(v);
  float kdotv = k.dot(v);

  float x = v.x * cos(theta) + kcrossv.x * sin(theta) + k.x * kdotv * (1 - cos(theta));
  float y = v.y * cos(theta) + kcrossv.y * sin(theta) + k.y * kdotv * (1 - cos(theta));
  float z = v.z * cos(theta) + kcrossv.z * sin(theta) + k.z * kdotv * (1 - cos(theta));
  
  PVector nv = new PVector(x, y, z);
  nv.normalize();

  return  nv;
}

PVector compute2DRotationVector(PVector k, float eta)
{
  float x = k.x * cos(eta) - k.y * sin(eta);
  float y = k.x * sin(eta) + k.y * cos(eta);

  return new PVector(x, y);
}

PVector compute3DRotationVector(PVector k, float eta, char axis)
{
  /*
  around Z-axis would be
   
   |cos θ   -sin θ   0| |x|   |x cos θ - y sin θ|   |x'|
   |sin θ    cos θ   0| |y| = |x sin θ + y cos θ| = |y'|
   |  0       0      1| |z|   |        z        |   |z'|
   
   around Y-axis would be
   
   | cos θ    0   sin θ| |x|   | x cos θ + z sin θ|   |x'|
   |   0      1       0| |y| = |         y        | = |y'|
   |-sin θ    0   cos θ| |z|   |-x sin θ + z cos θ|   |z'|
   
   around X-axis would be
   
   |1     0           0| |x|   |        x        |   |x'|
   |0   cos θ    -sin θ| |y| = |y cos θ - z sin θ| = |y'|
   |0   sin θ     cos θ| |z|   |y sin θ + z cos θ|   |z'|
   */
  if (axis == 'x' || axis == 'X')
  {
    float x = k.x * cos(eta) - k.y * sin(eta);
    float y = k.x * sin(eta) + k.y * cos(eta);
    float z = k.z;
    
    PVector v = new PVector(x, y, z);
    v.normalize();
    
    return v;
  } else if (axis == 'y' || axis == 'Y')
  {
    float x = k.x * cos(eta) + k.z * sin(eta);
    float y = k.y;
    float z = k.x * -1 * sin(eta) + k.z * cos(eta);
    PVector v = new PVector(x, y, z);
    v.normalize();
    
    return v;
  } else if (axis == 'z' || axis == 'Z')
  {
    float x = k.x;
    float y = k.y * cos(eta) - k.z * sin(eta);
    float z = k.y * sin(eta) + k.z * cos(eta);
    PVector v = new PVector(x, y, z);
    v.normalize();
    
    return v;
  } else
  {
    println("pick a correct axis of rotation");
    return null;
  }
}