public class Ripple
{
  float degreeAddMultiplier;
  float degreeAddBase;

  public Ripple(float radius, float addMultiplier, float addBase)
  {
    this.degreeAddMultiplier = addMultiplier;
    this.degreeAddBase = addBase;
    colorStyles.add(new RippleColorStyle(new float[] {0, 0, 100}, new boolean[] {false, true, false}, new boolean[] {true, false, false}, new float[] {radius, 7.0, 1.1}));
  }

  ArrayList<RippleColorStyle> colorStyles = new ArrayList<RippleColorStyle>();
  int selectedColorStyle = 0;

  public class RippleColorStyle
  {
    public float red;
    public float green;
    public float blue;
    public boolean redStatic;
    public boolean greenStatic;
    public boolean blueStatic;
    public boolean redReverse;
    public boolean greenReverse;
    public boolean blueReverse;
    public float radius;
    public float degreeAmountToAdd;
    public float decayAmount;

    public RippleColorStyle()
    {
      this.red = 0.0;
      this.green = 0.0;
      this.blue = 0.0;

      this.redStatic = false;
      this.greenStatic = false;
      this.blueStatic = false;

      this.redReverse = false;
      this.greenReverse = false;
      this.blueReverse = false;

      this.radius = 30.0;
      this.degreeAmountToAdd = 7.0;
      this.decayAmount = 1.0;
    }

    public RippleColorStyle(float[] colorValues)
    {
      this.red = colorValues[0];
      this.green = colorValues[1];
      this.blue = colorValues[2];

      this.redStatic = false;
      this.greenStatic = false;
      this.blueStatic = false;

      this.redReverse = false;
      this.greenReverse = false;
      this.blueReverse = false;

      this.radius = 30.0;
      this.degreeAmountToAdd = 7.0;
      this.decayAmount = 1.0;
    }

    public RippleColorStyle(float[] colorValues, boolean[] staticValues, boolean[] reverseValues, float[] shapeValues)
    {
      this.red = colorValues[0];
      this.green = colorValues[1];
      this.blue = colorValues[2];

      this.redStatic = staticValues[0];
      this.greenStatic = staticValues[1];
      this.blueStatic = staticValues[2];

      this.redReverse = reverseValues[0];
      this.greenReverse = reverseValues[1];
      this.blueReverse = reverseValues[2];

      this.radius = shapeValues[0];
      this.degreeAmountToAdd = shapeValues[1];
      this.decayAmount = shapeValues[2];
    }

    public RippleColorStyle(String[] data)
    {
      this.red = data.length > 0 ? float(data[0]) : 0.0;
      this.green = data.length > 1 ? float(data[1]) : 0.0;
      this.blue = data.length > 2 ? float(data[2]) : 0.0;

      this.redStatic = data.length > 3 ? boolean(int(data[3])) : false;
      this.greenStatic = data.length > 4 ? boolean(int(data[4])) : false;
      this.blueStatic = data.length > 5 ? boolean(int(data[5])) : false;

      this.redReverse = data.length > 6 ? boolean(int(data[6])) : false;
      this.greenReverse = data.length > 7 ? boolean(int(data[7])) : false;
      this.blueReverse = data.length > 8 ? boolean(int(data[8])) : false;

      this.radius = data.length > 9 ? float(data[9]) : 30.0;
      this.degreeAmountToAdd = data.length > 10 ? float(data[10]) : 7.0;
      this.decayAmount = data.length > 11 ? float(data[11]) : 1.0;
    }

    public String toString()
    {
      return "RGB: " + red + "," + green + "," + blue + "  Static: " + redStatic + "," + greenStatic + "," + blueStatic + "  Reverse: " + redReverse + "," + greenReverse + "," + blueReverse + "  Shape: " + radius + "," + degreeAmountToAdd + "," + decayAmount;
    }

    public String getExportString(String sep)
    {
      return int(red) + sep + int(green) + sep + int(blue) + sep + int(redStatic) + sep + int(greenStatic) + sep + int(blueStatic) + sep + int(redReverse) + sep + int(greenReverse) + sep + int(blueReverse) + sep + radius + sep + degreeAmountToAdd + sep + decayAmount;
    }
  }

  int rippleShapeType = 0;

  public class RippleObject
  {
    int rippleSize;
    int rippleX;
    int rippleY;
    float decay = 0.0;

    public RippleObject(int rippleSize, int rippleX, int rippleY)
    {
      this.rippleSize = rippleSize;
      this.rippleX = rippleX;
      this.rippleY = rippleY;
    }

    public void addToRipple()
    {
      rippleSize += 1;
    }

    public void drawRipple()
    {
      noStroke();
      fill(getRedColor(), getGreenColor(), getBlueColor(), 100.0-decay);

      switch (rippleShapeType)
      {
          case 0:
          drawHex(rippleX, rippleY, rippleSize/3.0);
          break;
          case 1:
          rectMode(CENTER);
          rect(rippleX, rippleY, rippleSize, rippleSize);
          break;
          case 2:
          ellipse(rippleX, rippleY, rippleSize, rippleSize);
          break;
      }

      noFill();
    }

    public void drawHex(float x, float y, float gs)
    {
      beginShape();
      vertex(x - gs, y - sqrt(3) * gs);
      vertex(x + gs, y - sqrt(3) * gs);
      vertex(x + 2 * gs, y);
      vertex(x + gs, y + sqrt(3) * gs);
      vertex(x - gs, y + sqrt(3) * gs);
      vertex(x - 2 * gs, y);
      endShape(CLOSE);
    }

    public void decayObject()
    {
      decay += colorStyles.get(selectedColorStyle).decayAmount;
    }

    public float getValueForMinusValue(float colorValue, boolean colorStatic, boolean colorReverse)
    {
      if (colorStatic)
      {
        return 255*colorValue/100;
      }
      else if (colorReverse)
      {
        return 255*(decay-colorValue)/100;
      }
      else
      {
        return 255*(colorValue-decay)/100;
      }
    }

    public float getRedColor()
    {
      float redMinus = colorStyles.get(selectedColorStyle).red;
      boolean redStatic = colorStyles.get(selectedColorStyle).redStatic;
      boolean redReverse = colorStyles.get(selectedColorStyle).redReverse;
      return getValueForMinusValue(redMinus, redStatic, redReverse);
    }

    public float getGreenColor()
    {
      float greenMinus = colorStyles.get(selectedColorStyle).green;
      boolean greenStatic = colorStyles.get(selectedColorStyle).greenStatic;
      boolean greenReverse = colorStyles.get(selectedColorStyle).greenReverse;
      return getValueForMinusValue(greenMinus, greenStatic, greenReverse);
    }

    public float getBlueColor()
    {
      float blueMinus = colorStyles.get(selectedColorStyle).blue;
      boolean blueStatic = colorStyles.get(selectedColorStyle).blueStatic;
      boolean blueReverse = colorStyles.get(selectedColorStyle).blueReverse;
      return getValueForMinusValue(blueMinus, blueStatic, blueReverse);
    }
  }

  public ArrayList<RippleObject> rippleArray = new ArrayList<RippleObject>();
  public int lastMouseX = 0;
  public int lastMouseY = 0;

  public void move()
  {
    translate(width/2, heightOffset+masterHeight/3);
    // colorStyles.get(0).red = (g.strokeColor>>16)&0xFF;
    // colorStyles.get(0).green = (g.strokeColor>>8)&0xFF;
    // colorStyles.get(0).blue = g.strokeColor&0xFF;

    for (int i=0; i < rippleArray.size(); i++)
    {
      RippleObject rippleObject = rippleArray.get(i);
      rippleObject.addToRipple();
      rippleObject.decayObject();
      rippleObject.drawRipple();

      if (rippleObject.decay >= 100.0)
      {
        rippleArray.remove(i);
      }
    }

    int[] rippleCoords = getRippleCoords();
    if (rippleCoords[0] == 1)
    {
      rippleArray.add(new RippleObject(1, rippleCoords[1], rippleCoords[2]));
    }

    translate(-width/2, -(heightOffset+masterHeight/3));
  }

  boolean mouseControlling = false;
  float lastDegree = 0.0;

  public int[] getRippleCoords()
  {
    if (mouseControlling)
    {
      boolean mouseChanged = (lastMouseX != mouseX || lastMouseY != mouseY);
      if (mouseChanged)
      {
        lastMouseX = mouseX;
        lastMouseY = mouseY;
      }
      return new int[]{mouseChanged ? 1 : 0, mouseX, mouseY};
    }
    else
    {
      //colorStyles.get(selectedColorStyle).degreeAmountToAdd;
      //lastDegree += 1.5*(timeOffsetDelta*150+1);
      lastDegree += degreeAddMultiplier*timeOffsetDelta+degreeAddBase;

      return new int[]{1, (int)(colorStyles.get(selectedColorStyle).radius*cos(lastDegree*PI/180)), (int)(colorStyles.get(selectedColorStyle).radius*sin(lastDegree*PI/180))};
    }
  }

  public void mousePressed()
  {
    switch (mouseButton)
    {
      case LEFT:
        switch (rippleShapeType)
        {
            case 0:
              rippleShapeType = 1;
              break;
            case 1:
              rippleShapeType = 2;
              break;
            case 2:
              rippleShapeType = 0;
              break;
        }
        break;
      case RIGHT:
        mouseControlling = !mouseControlling;
        break;
    }
  }
}
