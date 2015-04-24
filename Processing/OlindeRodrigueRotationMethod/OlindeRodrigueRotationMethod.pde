PVector computeRodrigueRotation(PVector k, PVector v, float theta)
{
  // Olinde Rodrigues formula : Vrot = v* cos(theta) + (k x v) * sin(theta) + k * (k . v) * (1 - cos(theta));
  PVector kcrossv = k.cross(v);
  float kdotv = k.dot(v);

  float x = v.x * cos(theta) + kcrossv.x * sin(theta) + k.x * kdotv * (1 - cos(theta));
  float y = v.y * cos(theta) + kcrossv.y * sin(theta) + k.y * kdotv * (1 - cos(theta));
  float z = v.z * cos(theta) + kcrossv.z * sin(theta) + k.z * kdotv * (1 - cos(theta));

  return new PVector(x, y, z);
}

