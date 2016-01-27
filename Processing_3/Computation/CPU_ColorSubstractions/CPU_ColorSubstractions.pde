
PImage source; //source image
PImage bg; //background image

PImage finalimage; //Off-screen buffer Image;
boolean colorReference; //boolean permetant de savoir si la couleur à soustraire a été configuré
ArrayList<Integer> colorRef; //Couleurs à soustraire
float res;
float size;

void setup()
{
  size(1280, 720, P3D);
  smooth(8);

  initVariables();
  initFaceDetect(source);
}

void draw()
{

  background(40);

  if (isColorReference())
  {
    image(finalimage, 0, 0);
    drawShape();
    showDebug(0.25);
  } else
  {
    showDebug(0.25);
    loadPixels();
    chooseColorReference();
    showDebugText();
  }

}

//Debug Display
void showDebug(float scale)
{
  pushStyle();
  imageMode(CORNER);
  image(source, 0, 0, source.width * scale, source.height * scale);
  image(bg, 0, source.height * scale, bg.width * scale, bg.height * scale);
  if (isColorReference())
  {
    float x = 0;
    float y = ((source.height * scale) * 2) - size;
    for (int i=0; i<colorRef.size (); i++)
    {
      color c = colorRef.get(i);
      if (i%res == 0)
      {
        x = 0;
        y += size;
      } else
      {
        x += size;
      }

      rectMode(CORNER);
      fill(c);
      stroke(255);
      rect(x, y, size, size);
    }
  }

  fill(255); 
  noStroke();
  text("FPS : "+round(frameRate), 10, height - 10);
  popStyle();
}

void showDebugText()
{
  pushStyle();
  fill(255);
  noStroke();
  textAlign(CENTER);
  text("Please take a color reference by clicking on a green pixel", width/2, height/2);
  popStyle();
}

void showDebugColor(int colorDebug, float x, float y, float size)
{
  pushStyle();
  rectMode(CENTER);
  fill(colorDebug);
  stroke(255);
  rect(x, y, size, size);
  popStyle();
}