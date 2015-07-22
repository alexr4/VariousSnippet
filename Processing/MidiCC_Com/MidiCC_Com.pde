Midi midiObj; 

float offset = 0;
float speedOffset = 0.05;
boolean up = true;
int minValue = 0;
int maxValue = 127;

void setup()
{
  midiObj = new Midi(this);
  defineMinMaxValues();
}

void draw()
{
  int channel = 0; 
  int number = 14; 
  int value = round(lerp(minValue, maxValue, offset));


  midiObj.silhouetteControlChange(channel, number, value);


  udpateDirection();
  checkEdge();
}

void udpateDirection()
{
  if (up)
  {
    offset += speedOffset;
  }
  else
  {
    offset -= speedOffset;
  }
}

void checkEdge()
{
  if (offset > 1 || offset < 0)
  {
    defineMinMaxValues();
    up = !up;
  }
}

void defineMinMaxValues()
{
  if (up)
  {
    minValue = round(random(0, maxValue));
  }
  else
  {
    maxValue = round(random(minValue, 127));
  }
}

void keyPressed()
{
  midiObj.startScanner();
}

