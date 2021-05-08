import ch.bildspur.vision.*;
import ch.bildspur.vision.result.*;

import processing.video.Capture;
import processing.net.*;

Capture cam;
Server myServer;

DeepVision vision;
ULFGFaceDetectionNetwork network;
ResultList<ObjectDetectionResult> detections;

public void setup() {
  size(640, 480, FX2D);
  colorMode(HSB, 360, 100, 100);

  println("start server...");
  // Starts a myServer on port 5204
  myServer = new Server(this, 5204); 

  println("creating network...");
  vision = new DeepVision(new PApplet());
  network = vision.createULFGFaceDetectorRFB320();

  println("loading model...");
  network.setup();

  println("setup camera...");
  cam = new Capture(this, "pipeline:autovideosrc");
  cam.start();
}

public void draw() {

  if (cam.available()) {
    cam.read();
  }

  if (cam.width == 0) {
    return;
  }

  detections = network.run(cam);

  image(cam, 0, 0);

  noFill();
  strokeWeight(2f);

  stroke(200, 80, 100);
  for (ObjectDetectionResult detection : detections) {
    myServer.write(map(detection.getX(), 0, width, 0, 1) + ":" + map(detection.getY(), 0, height, 0, 1) + "\n");
    rect(detection.getX(), detection.getY(), detection.getWidth(), detection.getHeight());
  }

  surface.setTitle("Face Detector Test - FPS: " + Math.round(frameRate));
}
