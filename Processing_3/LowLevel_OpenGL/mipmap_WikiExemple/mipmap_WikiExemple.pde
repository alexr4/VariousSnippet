// from : https://github.com/processing/processing/wiki/Advanced-OpenGL

/*
There is no corresponding PApplet method to change the filtering options, 
however the renderer class, PGraphicsOpenGL, exposes a function that can be 
used for that purpose, called textureSampling(int mode), 
where mode can take the values 2 (nearest), 3 (linear), 4 (bilinear), 
and 5 (trilinear)
*/

PImage img;
boolean highq = true;

void setup() {
  size(1280, 720, P3D);
  img = loadImage("Rosetta-Philae-67P-comete-29.png");
}

void draw() {
  translate(0, 0, -500);
  rotateX(QUARTER_PI);
  image(img, 0, 0);
}

void keyPressed() {
  if (highq) {
    hint(DISABLE_TEXTURE_MIPMAPS);
    ((PGraphicsOpenGL)g).textureSampling(2);
    highq = false;
    println("MipMaps has been disabled");
  } else {    
    hint(ENABLE_TEXTURE_MIPMAPS);
    ((PGraphicsOpenGL)g).textureSampling(5);
    highq = true;
    println("MipMaps has been enabled");
  }
}