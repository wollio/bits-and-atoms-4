/**
Task 5 Detecting Apples

Use the provided image and mark the green apples in the image. Check out the example code to extract hue values.
Additional: Implement a color picker that directly adapts to the sensed range.

@author David Wollschlegel <david@wollschlegel.com>
*/
import processing.video.*;
import gab.opencv.*;

OpenCV opencv;
Histogram histogram;

PImage img;

int lowerb = 46;
int upperb = 59;

void setup() {
  
  lowerb = round(map(lowerb, 0, 360, 0, 255));
  upperb = round(map(upperb, 0, 360, 0, 255));
  
  size(640, 480, FX2D);
  img = loadImage("apples.jpg");
  opencv = new OpenCV(this, img);
  opencv.useColor(HSB);
}

void draw() {
  
  opencv.loadImage(img);
  image(img, 0, 0, 640, 480);
  
  opencv.setGray(opencv.getH().clone());
  opencv.inRange(lowerb, upperb);
  
  blendMode(BLEND);
  image(img, 0, 0, 640, 480);
  blendMode(MULTIPLY);
  
  histogram = opencv.findHistogram(opencv.getH(), 255);
  
  image(opencv.getOutput(), 0, 0, 640, 480);
  
}
