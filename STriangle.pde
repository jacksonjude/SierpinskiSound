import java.awt.Color;

class STriangle {
  private int truex;
  private int truey;
  private float my;
  private float mx;
  private int leng;
  private int trianglenumt;
  private STriangle St1, St2, St3;
  private float rotationMultiplier;
  private int maxtri;
  public STriangle(int x, int y, int len, int trianglenum, int maxtriangles, float rotMult)
  {
    truex = x;
    truey = y;
    leng = len;
    trianglenumt = trianglenum;
    rotationMultiplier = rotMult;
    maxtri = maxtriangles;
    my = y + (int)(Math.random()*300 -150);
    mx = x + (int)(Math.random()*300 -150);
    if (my < masterLength/4) {
      int temp = masterLength/4;
      int tempb = (int)my - 0;
      changeStrokeColor(255, (255 * tempb)/temp, 0);
    } else if (my < masterLength/2) {
      int temp = masterLength/4;
      if (temp == 0) {
        temp = 1;
      }
      int tempb = (int)my - masterLength/4;
      changeStrokeColor(127 - (127 * tempb)/temp, 255, (255 * tempb)/temp);
    } else if (my < masterLength*3/4) {
      int temp = masterLength/4;
      if (temp == 0) {
        temp = 1;
      }
      int tempb = (int)my - masterLength/2;
      changeStrokeColor(0, 255 - (255 * tempb)/temp, 255);
    } else {
      int temp = masterLength/4;
      if (temp == 0) {
        temp = 1;
      }
      int tempb = (int)my - masterLength*3/4;
      changeStrokeColor(255-(127 * tempb)/temp, 0, 255);
    }
    beginShape();
    vertex(mx+leng/2, my);
    vertex(mx-leng/2, my);
    vertex(mx, (float)(my+leng/2*Math.sqrt(3)));
    vertex(mx+leng/2, my);
    endShape();
    beginShape();
    vertex(x+len/2, y);
    vertex(x-len/2, y);
    vertex(x, (float)(y+len/2*Math.sqrt(3)));
    vertex(x+len/2, y);
    endShape();

    if (trianglenum < maxtri) {
      St1 = new STriangle(x - len/4, y, len/2, trianglenum+1, maxtri, rotationMultiplier);
      St2 = new STriangle(x, (int)(y+len/4*Math.sqrt(3)), len/2, trianglenum+1, maxtri, rotationMultiplier);
      St3 = new STriangle(x+len/4, y, len/2, trianglenum+1, maxtri, rotationMultiplier);
    }
  }
  public void moveBack(float multi) {
    my += multi*(truey-my)/10;
    mx += multi*(truex-mx)/10;
    if (trianglenumt < maxtri) {
      St1.moveBack(multi);
      St2.moveBack(multi);
      St3.moveBack(multi);
    }
  }
  public void seperate(float multi, float sepX, float sepY) {
    float distance = (dist(mx, (float)(my + leng * (Math.sqrt(3)/4)), sepX, sepY));
    if (distance < 1) {
      distance = 1;
    }
    my += 5*multi*Math.sqrt(trianglenumt) * (Math.random() * 3)*(10)/((distance)/20)* (Math.abs(my - sepY)/(my-sepY));
    mx += 5*multi*Math.sqrt(trianglenumt) * (Math.random() * 3)*(10)/((distance)/20)* (Math.abs(mx - sepX)/(mx-sepX));
    if (trianglenumt < maxtri) {
      St1.seperate(multi, sepX, sepY);
      St2.seperate(multi, sepX, sepY);
      St3.seperate(multi, sepX, sepY);
    }
  }
  public void move() {
    float colorY = truey-heightOffset;
    //if (false) {
      //if (colorY < masterLength/4) {
      //  int temp = masterLength/4;
      //  int tempb = (int)colorY - 0;
      //  changeStrokeColor(255, (255 * tempb)/temp, 0);
      //} else if (colorY < masterLength/2) {
      //  int temp = masterLength/4;
      //  if (temp == 0) {
      //    temp = 1;
      //  }
      //  int tempb = (int)colorY - masterLength/4;
      //  changeStrokeColor(127 - (127 * tempb)/temp, 255, (255 * tempb)/temp);
      //} else if (colorY < masterLength*3/4) {
      //  int temp = masterLength/4;
      //  if (temp == 0) {
      //    temp = 1;
      //  }
      //  int tempb = (int)colorY - masterLength/2;
      //  changeStrokeColor(0, 255 - (255 * tempb)/temp, 255);
      //} else {
      //  int temp = masterLength/4;
      //  if (temp == 0) {
      //    temp = 1;
      //  }
      //  int tempb = (int)colorY - masterLength*3/4;
      //  changeStrokeColor(255-(127 * tempb)/temp, 0, 255);
      //}
    //} else {

    if (colorY < masterLength/4) {
      int temp = masterLength/4;
      int tempb = (int)colorY - 0;
      changeStrokeColor(255, (255 * tempb)/temp, 0);
    } else if (colorY < masterLength/2) {
      int temp = masterLength/4;
      if (temp == 0) {
        temp = 1;
      }
      int tempb = (int)colorY - masterLength/4;
      changeStrokeColor(127 - (127 * tempb)/temp, 255, (255 * tempb)/temp);
    } else if (colorY < masterLength*3/4) {
      int temp = masterLength/4;
      if (temp == 0) {
        temp = 1;
      }
      int tempb = (int)colorY - masterLength/2;
      changeStrokeColor(0, 255 - (255 * tempb)/temp, 255);
    } else {
      int temp = masterLength/4;
      if (temp == 0) {
        temp = 1;
      }
      int tempb = (int)colorY - masterLength*3/4;
      changeStrokeColor(255-(127 * tempb)/temp, 0, 255);
    }

    if (shouldRotateAll)
    {
      translate(width/2, heightOffset+masterHeight/3);
      rotate(rotationMultiplier*2*PI*timeOffset);
      translate(-width/2, -(heightOffset+masterHeight/3));
    }
    else if (trianglenumt == 0)
    {
      translate(width/2, heightOffset+masterHeight/3);
      rotate(rotationMultiplier*2*PI*timeOffset/4);
      translate(-width/2, -(heightOffset+masterHeight/3));
    }

    beginShape();
    vertex(mx+leng/2, my);
    vertex(mx-leng/2, my);
    vertex(mx, (float)(my+leng/2*Math.sqrt(3)));
    vertex(mx+leng/2, my);
    endShape();

    if (shouldRotateAll)
    {
      translate(width/2, (heightOffset+masterHeight/3));
      rotate(rotationMultiplier*-(2*PI*timeOffset));
      translate(-width/2, -(heightOffset+masterHeight/3));
    }
    else if (trianglenumt == 0)
    {
      translate(width/2, (heightOffset+masterHeight/3));
      rotate(rotationMultiplier*-2*PI*timeOffset/4);
      translate(-width/2, -(heightOffset+masterHeight/3));
    }

    if (trianglenumt < maxtri) {
      St1.move();
      St2.move();
      St3.move();
    }
  }

  public void changeStrokeColor(int r, int g, int b)
  {
    if (shouldChangeColor)
    {
      float[] hsbVals = Color.RGBtoHSB(r, g, b, null);
      hsbVals[0] += timeOffset;
      while (hsbVals[0] > 1.0)
        hsbVals[0] -= 1.0;

      Color rgbColor = new Color(Color.HSBtoRGB(hsbVals[0], hsbVals[1], hsbVals[2]));

      stroke(rgbColor.getRed(), rgbColor.getGreen(), rgbColor.getBlue());
    }
    else
    {
      stroke(r, g, b);
    }
  }
}
