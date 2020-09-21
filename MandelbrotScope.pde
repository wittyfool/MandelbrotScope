int infoX = 610;
int infoY = 20;
int countMax = 300;
int countOverHalf = 0;
int countOverThreeFourth = 0;
double x=0, y=0, scale=4.0;
boolean redraw = false;
int order16[] = { 0, 8, 4, 12, 2, 6, 10, 14, 1, 3, 5, 7, 9, 11, 13, 15 };

void setup() {
  size(800, 600);
  colorMode(HSB, 200, 100, 100);

  background(0, 0, 0);
  drawInfo();
  redraw = true;
  thread("myThread");
  frameRate(10);
}

int mandel(double rr, double ii) {
  int cc;
  double zr=0, zi=0;
  double zr2, zi2;
  
  for (cc=0; cc<countMax; cc++) {
    zr2 = zr * zr;
    if (zr2 > 4.0) break;
    zi2 = zi * zi;
    if (zi2 > 4.0) break;
    zi = 2.0 * zr * zi + ii;
    zr = zr2 - zi2 + rr;
    if ((zr2+zi2) > 4.0) break;
  }
  if (cc == countMax) {
    return 0;
  }
  return cc;
}

void myThread() {
  int px, py;
  int count, mod;
  color c;
  double re, im;

  do {
    if (!redraw) {
      delay(200);
    } else {
      loadPixels();
      redraw = false;

      c = color(0, 0, 55);
      for (py=0; py<600; py++) {
        for (px=0; px<600; px++) {
          pixels[py*800+px] = int(c);
        }
      }

      countOverHalf = 0;
      countOverThreeFourth = 0;
      for (mod=0; mod<16; mod++) {
        if (redraw) break;
        for (py=0; py<600; py+=16) {
          if ((py + order16[mod]) >= 600) continue;
          im = y + (double)(300 - py - order16[mod]) * scale / 300.0;
          for (px=0; px<600; px++) {
            re = x + (double)(px - 300) * scale /300.0;
            count = mandel(re, im);
            c = count == 0 ? color(0, 0, 0) : color(count % 200, 100, 100);
            pixels[(py + order16[mod])*800+px] = int(c);

            if (count > countMax/2) {
              countOverHalf++;
            }
            if (count > countMax*3/4) {
              countOverThreeFourth++;
            }
          }
        }
        updatePixels();
      }
    }
  } while (true);
}

void drawInfo() {
  float per;

  per = (float)countOverThreeFourth * 100.0 / (float)(800*800);

  fill(0, 0, 0);
  rect(600, 0, 200, 600);
  fill(0, 0, 100);
  text("x=" + str((float)x), infoX, infoY);
  text("y=" + str((float)y), infoX, infoY+20);
  text("scale=" + str((float)scale), infoX, infoY+40);
  text("countMax=" + str(countMax), infoX, infoY+60);
  text("countOverHalf=" + str(countOverHalf), infoX, infoY+80);
  text("countOver3/4=" + str(countOverThreeFourth), infoX, infoY+100);
  text("per="+str(per), infoX, infoY+120);
}

void mousePressed() {
  x += (double)(pmouseX - 300)/600.0 * scale;
  y -= (double)(pmouseY - 300)/600.0 * scale;
  if (mouseButton == LEFT) {
    if ( keyPressed && keyCode ==SHIFT) {
      scale *= 1.25;
    } else {
      scale *= 0.75;
    }
  } else {
    scale *= 1.25;
  }
  redraw = true;
}

void keyPressed() {
  boolean noRedraw = false;

  if (key == 'u') {
    countMax = countMax * 3 / 2;
  } else if (key == 'U') {
    countMax = countMax / 2;
  } else if (key == 'z') {
    scale *= 0.75;
  } else if (key == 'Z') {
    scale *= 1.25;
  } else if (keyCode == UP) {
    y += (scale * 0.2);
  } else if (keyCode == DOWN) {
    y -= (scale * 0.2);
  } else if (keyCode == RIGHT) {
    x += (scale * 0.2);
  } else if (keyCode == LEFT) {
    x -= (scale * 0.2);
  } else {
    noRedraw = true;
  }

  redraw = !noRedraw;
}

void draw() {
  //updatePixels();
  drawInfo();
}
