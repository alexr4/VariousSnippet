import processing.video.*;

String format;
String nomDeLaVideo = "fountain-3D-4k";
Movie movie;
PShape rectObj;
PShader textShader;
PGraphics textureWrapper;
boolean forward, backward;
int clicCount;
float angle;

//PGraphics final
PGraphics BufferScreen;

//debug
float timePerFrame;
float lastTime;


void setup() {
  size(1920, 1080, P3D);
  background(0);
  //frameRate(30);

  forward = false;
  backward = false;
  format = ".mp4";
  movie = new Movie(this, nomDeLaVideo+format);
  movie.play();
 // movie.frameRate = 12;
  


  textureWrapper = createGraphics(4096, 4096, P3D);

  rectObj = objShape();
  textShader = loadShader("frag.glsl", "vert.glsl");

  // println("movie.frameRate : "+movie.frameRate);
  println("movie.hasBufferSink : "+movie.hasBufferSink());

  BufferScreen = createGraphics(4096, 4096, P3D);
}

void playMovie(Movie m)
{

  if (forward)
  {
    println("\tplay forward");
    m.pause();
    //m.speed(1.0);
    m.play();
    forward = false;
  }
  if (backward)
  {
    println("\tplay backward");
    m.pause();
    //m.speed(-1.0);
    m.play();
    backward = false;
  }
}

void computeOffscreenTexture(Movie m) {
  if (m.available())
  {
    m.read();
    textureWrapper.beginDraw();
    textureWrapper.background(0);
    textureWrapper.image(m, 0, 0);//, textureWrapper.width, textureWrapper.height);
    textureWrapper.endDraw();
    textShader.set("Visite", textureWrapper);
    timePerFrame = millis() - lastTime;
    lastTime = millis();
  } else
  {
  }
}

PGraphics computeFinalBufferScreen()
{
  BufferScreen.beginDraw();
  BufferScreen.background(0, 0, 255);
  BufferScreen.pushMatrix();
  sceneControl(BufferScreen);
  BufferScreen.shape(rectObj);
  BufferScreen.popMatrix();
  BufferScreen.endDraw();

  return BufferScreen;
}

void draw() {
  background(0);

  //playMovie(movie);
  computeOffscreenTexture(movie);

  imageMode(CENTER); 
  image(computeFinalBufferScreen(), width/2, height/2, height, height);

  imageMode(CORNER);
  image(textureWrapper, 0, 0, textureWrapper.width*.1, textureWrapper.height*.1);



  showFrameRate(true);
  if (mousePressed)
  {
    //movie.dispose();
  }
}

void showFrameRate(boolean show)
{
  if (show)
  {
    frame.setTitle("CPU FPS : "+round(frameRate)+" Movie Playback : "+round(movie.time())+" / "+round(movie.duration())+" Movie FPS : "+movie.frameRate+" Time per Frame : "+(timePerFrame/1000)+" seconds");
  } else
  {
    frame.setTitle("hd Movie + offscreen texture shader");
  }
}

void sceneControl(PGraphics buff)
{
  buff.translate(buff.width/2, buff.height/2, -3000);
  buff.rotateY(angle);
  angle+=0.001;
}

PShape objShape()
{
  float res = 1;//(movie.width + 0.0) / (movie.height + 0.0);
  float ox = 4096;//movie.width;
  float oy = ox/res;


  PShape obj = createShape();

  obj.beginShape(QUAD);
  obj.textureMode(NORMAL);
  obj.noStroke();
  obj.texture(textureWrapper);
  obj.vertex(-ox, -oy, 0, 0, 0);
  obj.vertex(ox, -oy, 0, 1, 0);
  obj.vertex(ox, oy, 0, 1, 1);
  obj.vertex(-ox, oy, 0, 0, 1);
  obj.endShape();

  return obj;
}


void mousePressed()
{
  clicCount ++;
  println(clicCount);
  if (clicCount%2 == 0)
  {
    forward = !forward;
  } else
  {
    backward = !backward;
  }
  println("forward : "+forward);
  println("backward : "+backward);
}

