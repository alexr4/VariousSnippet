import themidibus.*;

public class Midi {

  PApplet app;
  MidiBus midi;
  boolean particlesFallStarted;

  Midi(PApplet app_) {
    app = app_;

    midi = new MidiBus(app, -1, 1);
  }

  void startScanner() {
    midi.sendNoteOn(0, 36, 127);
  }

  void startSilhouette(int channel, int note) {
    midi.sendNoteOn(channel, note, 127);
  }

  void stopSilhouette(int channel, int note) {
    midi.sendNoteOff(channel, note, 127);
  }

  void silhouetteControlChange(int channel, int number, int value) {
    midi.sendControllerChange(channel, number, value);
    //println(channel+" "+value);
  }

  void startParticulesFall() {
    if (!particlesFallStarted) {
      midi.sendNoteOn(0, 53, 127);
      particlesFallStarted = true;
    }
  }
}

