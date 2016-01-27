PVector getNewMappedLocation(PVector loc, int newOriginX, int newOriginY)
{
  return new PVector(loc.x - newOriginX, loc.y - newOriginY);
}