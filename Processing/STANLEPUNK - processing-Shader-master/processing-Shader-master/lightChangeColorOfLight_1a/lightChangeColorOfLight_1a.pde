PShape can;
float angle;

PShader pixlightShader;

void setup() {
  size(640, 360, P3D);
  can = createCan(100, 200, 32);
  pixlightShader = loadShader("pixlightfrag.glsl", "pixlightvert.glsl");
}

void draw() {    
  background(0);
  
  shader(pixlightShader);
  
  // pointLight(0, 0, 0, mouseX, mouseY, 200);
  
  float redData = 255 *cos(frameCount *.01) ;
  float greenData = 255 *sin(frameCount *.02) ;
  float blueData = 255 *sin(frameCount *.001) ;
  Vec3 colorLight = new Vec3(redData, greenData, blueData) ;
  float posLightX = mouseX ;
  float posLightY = mouseY ;
  float posLightZ = 200 ;
  Vec3 posLight = new Vec3(posLightX, posLightY, posLightZ) ;
  float dirX = -1 ;
  float dirY = 0 ;
  float dirZ = 0 ;
  Vec3 dirLight = new Vec3(dirX, dirY, dirZ) ;
  float angle = PI/8 ;
  float concentration = 800; // try 1 > 1000
  
  spotLightShader(colorLight, posLight,dirLight, angle, concentration, pixlightShader) ;
  //pointLight(255, 255, 255, -mouseX, mouseY, 200);

  translate(width/2, height/2);
  rotateY(angle);  
  shape(can);  
  angle += 0.01;
  

}

//
void spotLightShader(Vec3 colorLight, Vec3 pos, Vec3 dir, float angle, float concentration, PShader s) {
    spotLight(0, 0, 0, pos.x, pos.y, pos.z, dir.x, dir.y, dir.z, angle, concentration) ;
      //transfert data color of light to shader
  PVector c = new PVector(colorLight.r,colorLight.g,colorLight.b) ;
  s.set("colorLight", c) ;
}





// object
PShape createCan(float r, float h, int detail) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  sh.fill(255,255,255) ;
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);    
  }
  sh.endShape(); 
  return sh;
}
