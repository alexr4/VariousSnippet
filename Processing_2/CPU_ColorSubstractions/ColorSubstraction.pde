
void chooseColorReference()
{
  if (mousePressed)
  {
    for (int i=0; i<res; i++)
    {
      for (int j=0; j<res; j++)
      {
        int x = floor((mouseX - ((res * size/2) / 2)) + j * (size/2));
        int y = floor((mouseY - ((res * size/2) / 2)) + i * (size/2));

        color c = 0;
        try
        {
          c = pixels[y*width+x];

        }
        catch(Exception e)
        {
        }
        
          showDebugColor(c, x, y, size);
      }
    }
  }
}

//Computation
void computeBackgroundSubstration()
{
  if (isColorReference())
  {
    finalimage =  bg.get();
    source.loadPixels();
    finalimage.loadPixels();
    for (int i = 0; i < source.pixels.length; i++) {
      for (int j=0; j<colorRef.size (); j++)
      {
        color colorref = colorRef.get(j);
        color sourcePixel = source.pixels[i];

        float green00 = colorref >> 8 & 0xFF;
        float green01 = sourcePixel >> 8 & 0xFF;   

        if (green01 >= green00) {
        } else {
          finalimage.pixels[i]  = source.pixels[i];
        }
      }
    }
    // We changed the pixels in destination
    finalimage.updatePixels();
  } else
  {
  }
}

//Interactions
void mouseReleased()
{
  if (colorReference == false)
  {
    for (int i=0; i<res; i++)
    {
      for (int j=0; j<res; j++)
      {
        int x = floor((mouseX - ((res * size/2) / 2)) + j * (size/2));
        int y = floor((mouseY - ((res * size/2) / 2)) + i * (size/2));

        color c = 0;
        try
        {
          c = pixels[y*width+x];

          colorRef.add(c);
        }
        catch(Exception e)
        {
        }
      }
    }
    colorReference = true;

    computeBackgroundSubstration();
  }
}

void keyPressed()
{
  if (key == 'n')
  {
    colorRef.clear();
    colorReference = false;
  }
}

//getMethode
boolean isColorReference()
{
  return colorReference;
}

