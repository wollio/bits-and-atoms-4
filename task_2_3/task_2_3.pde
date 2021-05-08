/**
Task 6 Locate Apples

Locate the position of the extracted apples with the contour detection. 
Try to indicate the position with a circle or directly draw the area.

Additional: Use the apples as input device for the interactive drawing or another application (a game?)

@author David Wollschlegel <david@wollschlegel.com>
*/
import processing.video.*;
import gab.opencv.*;

OpenCV opencv;
Histogram histogram;

String[] cameras = Capture.list();
Capture cam;

PImage img;

int lowerb = 60;
int upperb = 80;

void setup() {
  
  lowerb = round(map(lowerb, 0, 360, 0, 255));
  upperb = round(map(upperb, 0, 360, 0, 255));
  
  size(640, 480, FX2D);
  
  cam = new Capture(this, 640, 480, cameras[0]);
  
  opencv = new OpenCV(this, cam);
  cam.start();
}

void draw() {
  
  if (cam.available()) {
    cam.read();
  }
  
  opencv.useColor(HSB);
  opencv.loadImage(cam);
  
  opencv.threshold(150);
  
  opencv.setGray(opencv.getH().clone());
  opencv.inRange(lowerb, upperb);
  
  blendMode(BLEND);
  image(cam, 0, 0, 640, 480);
  //blendMode(MULTIPLY);
  image(opencv.getOutput(), 0, 0, 640, 480);
  
  for (Contour contour : opencv.findContours()) {
    if (contour.area() > 2000) {
      stroke(255, 0, 0);
      fill(255, 0, 0, 100);
      contour.draw();
      int x = (int) contour.getBoundingBox().getCenterX();
      int y = (int) contour.getBoundingBox().getCenterY();
    
      push();
      
      fill(color(255, 0,0));
      circle(x, y, 20);
      pop();
      
    }
  }
  
  
  color pixel = cam.get(mouseX, mouseY);
  println("Hue: " + hue(pixel));
  
}
