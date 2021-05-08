/**
Task 4 Brightest Spot Tracking OpenCV
Use OpenCV to track the brightest spot in the image (interactive paint with OpenCV).
opencv.blur(10);
PVector location = opencv.max();

@author David Wollschlegel <david@wollschlegel.com>
*/
import processing.video.*;
import gab.opencv.*;

String[] cameras = Capture.list();
PVector moonPos = new PVector(0, 0);
float brightestValue = 0.0;

Capture cam;
OpenCV opencv;

void setup() {
  size(640, 480, FX2D);
  cam = new Capture(this, 640, 480, cameras[0]);
  
  opencv = new OpenCV(this, 640, 480);
  
  cam.start();
}

void draw() {
  if (cam.available()) {
    cam.read();
  }
  
  opencv.loadImage(cam);
  opencv.blur(10);
  PVector location = opencv.max();
  
  image(opencv.getSnapshot(), 0, 0);
  
  circle(location.x, location.y, 30);
}
