import processing.sound.*;
Amplitude amp;
AudioIn in;
String[] soundList = Sound.list();
int selectedAudioOutput = 0;
float[][] audioWeights = new float[][]{new float[]{8, 1.5}, new float[]{12, 2}, new float[]{50, 6}};
float audioMulti = 12;
float audioPow = 2;
int masterLength;

FFT fft;
int bands = 1024;
float[] spectrum = new float[bands];

CommandLine cl = new CommandLine();

int maxtri = 9;
boolean changeColor = false;
STriangle MasterTriangle;
boolean toggle = true;
public boolean increase = false;
float multiplier = 1;

public void setup()
{
  noFill();  
  background(255);
  size(750, 750);
  surface.setResizable(true);
  
  restartSound();
  
  masterLength = (int)(width*0.6);
  masterHeight = sqrt(3)*masterLength/2;
  heightOffset = 0.25*height;
  
  MasterTriangle = new STriangle(width/2, (int)(heightOffset), masterLength, 0);
  maxtri = 6;
}

float heightOffset;
float masterHeight;

public void restartSound()
{
  Sound s = new Sound(this);
  s.inputDevice(selectedAudioOutput);
  s.outputDevice(2);
  amp = new Amplitude(this);
  in = new AudioIn(this);
  in.play();
  amp.input(in);
  fft = new FFT(this, bands);
  fft.input(in);
}

float rotation = 0;

public void draw()
{
  if (floor(width) != floor(height))
  {
    surface.setSize(width, width);
  }
  
  //println(mouseX, mouseY);
  
  background(0);
  rotation += 0.01;
  float ampSound = amp.analyze();
  fft.analyze(spectrum);
  
  float fftBassAvg = 0;
  for (int i=0; i < 10; i++)
  {
    fftBassAvg += spectrum[i];
  }
  fftBassAvg /= 10;
  
  float fftMedAvg = 0;
  for (int i=10; i < 30; i++)
  {
    fftMedAvg += spectrum[i];
  }
  fftMedAvg /= 20;
  
  float fftTrebleAvg = 0;
  for (int i=30; i < spectrum.length; i++)
  {
    fftTrebleAvg += spectrum[i];
  }
  fftTrebleAvg /= spectrum.length-30;
  
  cl.show(selectedAudioOutput, soundList.length, ampSound);
  
  //fill(fftTrebleAvg*audioWeights[2][0], fftMedAvg*audioWeights[1][0], fftBassAvg*audioWeights[0][0]);
  
  MasterTriangle.move();
  MasterTriangle.seperate((float)Math.pow(audioMulti*fftMedAvg, audioPow), width/2.0, 0.125*height+masterHeight*1/4);
  MasterTriangle.seperate((float)Math.pow(audioWeights[0][0]*fftBassAvg, audioWeights[0][1]), width/2.0, 0.125*height+masterHeight*5/8);
  //MasterTriangle.seperate((float)Math.pow(audioWeights[1][0]*fftMedAvg, audioWeights[1][1]), (width-masterLength)/2+masterLength/4, 0.125*height+masterHeight*1/8);
  //MasterTriangle.seperate((float)Math.pow(audioWeights[1][0]*fftMedAvg, audioWeights[1][1]), (width-masterLength)/2+masterLength*3/4, 0.125*height+masterHeight*1/8);
  MasterTriangle.moveBack(2);
  
  colorMode(HSB);
  stroke(0, 0);
  int displayBands = 512;
  for (int i=0; i < displayBands; i++)
  {
    fill(spectrum[i]*255*3, 255, 255);
    rect((i)*width*1.0/(displayBands), height, width*1.0/(displayBands), -(spectrum[i]*height+height/100));
  }
  colorMode(RGB);
  fill(0, 0);
}
public void mousePressed()
{
  increase = true;
}
public void mouseReleased() {
  increase = false;
}
public void keyPressed() {
  /*if (key == 'w') {
    if (maxtri < 9) {
      maxtri++;
    }
  }
  if (key == 's') {
    if (maxtri > 1) {
      maxtri--;
    }
  }
  if (key == 'e') {
    if (toggle) {
      changeColor = !changeColor;
      toggle = false;
    }
  }*/
  
  cl.pressingKey(keyCode);
}
public void keyReleased() {
  if (key == 'e') {
    toggle = true;
  }
  
  cl.releasedKey(keyCode);
}