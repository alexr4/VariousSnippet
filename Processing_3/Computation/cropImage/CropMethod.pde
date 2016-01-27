PImage cropImage(int fromx, int fromy, int newWidth, int newHeight, PImage src)
{
  PImage tmp = new PImage(newWidth, newHeight);
  
  for(int i=0; i<newWidth * newHeight; i++)
  {
    float x = fromx + i % newWidth;
    float y = fromy + (i-x) / newWidth;
    int indexOnSource = int(x + y * src.width);
    tmp.pixels[i] = src.pixels[indexOnSource];
  }
  
  return tmp;
}

PImage cropRotatedImage(int fromx, int fromy, int newWidth, int newHeight, PImage src)
{
  PImage tmp = new PImage(newWidth, newHeight);
  
  for(int i=0; i<newWidth * newHeight; i++)
  {
    float y = newWidth - (i % newWidth) + fromx;
    float x = fromy + (i-y) / newWidth;
    int indexOnSource = int(x + y * src.width);
    tmp.pixels[i] = src.pixels[indexOnSource];
  }
  
  return tmp;
}