import processing.sound.*;
import java.math.BigDecimal;
import java.math.RoundingMode;

boolean soundStarted = false;
Sound s;
Amplitude amp;
AudioIn in;
FFT fft;
int bands = 1024;
float[] spectrum = new float[bands];

String[] soundList = Sound.list();
int selectedAudioOutput = 0;
int selectedAudioInput = 3;

float[][] audioWeights = new float[][]{new float[]{8, 1.5}, new float[]{12, 2}, new float[]{50, 6}};
float audioMulti = 12;
float audioPow = 2;
int masterLength;

CommandLine cl = new CommandLine();

int maxTriangles = 6;
STriangle MasterTriangle;
ArrayList<STriangle> SecondaryTriangles;
int[] triangleRotationMultipliers = new int[]{-1, 2, -2, 3, -3, 4, -4};

boolean shouldChangeColor = true;
boolean shouldRotateAll = false;
float masterColorRotateMultiplier = 7;
float timeOffset = 0;
float timeOffsetDelta = 0;

SpinningCircle insideCircle;
float insideCircleStroke;

int previousWidth;
int previousHeight;

public void setup()
{
  noFill();
  background(255);
  size(700, 700);
  surface.setResizable(true);

  PImage icon = loadImage("icon.png");
  surface.setIcon(icon);

  createShapes();
}

public void createShapes()
{
  masterHeight = (int)(height/2.0);
  masterLength = (int)(2.0*masterHeight/sqrt(3));
  heightOffset = 0.25*height;

  MasterTriangle = new STriangle(width/2, (int)(heightOffset), masterLength, 0, maxTriangles, 1);
  SecondaryTriangles = new ArrayList<STriangle>();
  for (int i=0; i < triangleRotationMultipliers.length; i++)
    SecondaryTriangles.add(new STriangle(width/2, (int)(heightOffset), masterLength, 0, /*(i == 0 ? maxTriangles : 0)*/0, triangleRotationMultipliers[i]));

  insideCircleStroke = ceil(1.0*width/200);
  insideCircle = new SpinningCircle(15, masterHeight/6, insideCircleStroke);
}

float heightOffset;
float masterHeight;

public void restartSound()
{
  if (!soundStarted)
  {
    soundStarted = true;
    s = new Sound(this, 44100, selectedAudioOutput, selectedAudioInput, 1.0);
    in = new AudioIn(this);
    in.play();
    amp = new Amplitude(this);
    amp.input(in);
    fft = new FFT(this, bands);
    fft.input(in);
  }
  else
  {
    s.inputDevice(selectedAudioInput);
    s.outputDevice(selectedAudioOutput);
  }
}

public void draw()
{
  if (previousWidth != width || previousHeight != height)
    createShapes();
  previousWidth = width;
  previousHeight = height;

  if (!soundStarted)
  {
    background(0);
    cl.show(soundList.length, 0, 0, frameRate);
  }
  else
  {
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

    background(0);

    if (shouldChangeColor)
    {
      double ampOffsetShift = 0.001*Math.pow(ampSound, 1.0/1.5);
      double bassOffsetShift = 0.01*(Math.pow(7, fftBassAvg)-1);
      timeOffsetDelta = (float)(masterColorRotateMultiplier*(ampOffsetShift+bassOffsetShift));
      timeOffset += timeOffsetDelta;

      // if (ampOffsetShift+bassOffsetShift > 0.0)
      //   println(this.round(ampOffsetShift/(ampOffsetShift+bassOffsetShift), 3), this.round(bassOffsetShift/(ampOffsetShift+bassOffsetShift), 3));
    }

    cl.show(soundList.length, (float)this.round(ampSound, 3), (float)this.round(timeOffset, 3), frameRate);

    MasterTriangle.seperate((float)Math.pow(audioMulti*fftMedAvg, audioPow), width/2.0, 0.125*height+masterHeight*1/4);
    MasterTriangle.seperate((float)Math.pow(audioWeights[0][0]*fftBassAvg, audioWeights[0][1]), width/2.0, 0.125*height+masterHeight*5/8);
    //SecondaryTriangles.get(0).seperate((float)Math.pow(audioMulti*fftMedAvg, audioPow), width/2.0, 0.125*height+masterHeight*1/4);
    //SecondaryTriangles.get(0).seperate((float)Math.pow(audioWeights[0][0]*fftBassAvg, audioWeights[0][1]), width/2.0, 0.125*height+masterHeight*5/8);

    //MasterTriangle.seperate((float)Math.pow(audioWeights[1][0]*fftMedAvg, audioWeights[1][1]), (width-masterLength)/2+masterLength/4, 0.125*height+masterHeight*1/8);
    //MasterTriangle.seperate((float)Math.pow(audioWeights[1][0]*fftMedAvg, audioWeights[1][1]), (width-masterLength)/2+masterLength*3/4, 0.125*height+masterHeight*1/8);

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

  for (STriangle triangle : SecondaryTriangles)
  {
    triangle.move();
  }

  ellipse(width/2, heightOffset+masterHeight/3, masterHeight/3+1, masterHeight/3+1);
  ellipse(width/2, heightOffset+masterHeight/3, 2*masterHeight/3+1, 2*masterHeight/3+1);
  ellipse(width/2, heightOffset+masterHeight/3, 4*masterHeight/3+1, 4*masterHeight/3+1);

  MasterTriangle.move();

  MasterTriangle.moveBack(2);
  for (STriangle triangle : SecondaryTriangles)
  {
    triangle.moveBack(2);
  }

  insideCircle.move();
}

public void keyPressed() {
  cl.pressingKey(keyCode);
}

public void keyReleased() {
  if (keyCode == SHIFT)
  {
    restartSound();
  }
  cl.releasedKey(keyCode);
}

public double round(double value, int places) {
    if (places < 0) throw new IllegalArgumentException();

    BigDecimal bd = BigDecimal.valueOf(value);
    bd = bd.setScale(places, RoundingMode.HALF_UP);
    return bd.doubleValue();
}
