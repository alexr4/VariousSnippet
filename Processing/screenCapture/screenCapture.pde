int frameRateCapture;
int totalTimeCapture;
int frameCapture;
Timer timerCapture;
PImage capture;

void captureSetup() {
  capture = createImage(width, height, RGB);
  frameRateCapture = 16;
  totalTimeCapture = round(1000/frameRateCapture);
  frameCapture = 0;
  timerCapture = new Timer(totalTimeCapture);
  timerCapture.start();
}

void captureRun()
{
  if (timerCapture.isFinished())
  {
    capture = visualController.offscreen.get();
    
    thread("saveCapture");

    frameCapture += 1;
    timerCapture.setTotalTime(totalTimeCapture);
    timerCapture.reset();
    timerCapture.start();
  }
}

void saveCapture()
{
  capture.save("/captureVideo/stimula_000000000"+frameCapture+".tiff");
  //saveFrame("/captureVideo/stimula_000"+frameCapture+".tiff");
}

