char a = '1';
char b = '4';
char c = '2';
char[] data = {a, b, c};


void setup()
{
  String dataToString = new String(data);
  println(dataToString);
  
  int value = int(dataToString);
  println(value);
}

void draw()
{
 
}