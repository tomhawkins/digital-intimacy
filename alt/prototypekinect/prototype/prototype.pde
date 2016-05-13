//import org.openkinect.*;
//import org.openkinect.processing.*;

import org.openkinect.*;
import org.openkinect.processing.*;

Kinect kinect;

boolean depth = true;
boolean rgb = false;

  
  PImage close_1;
  PImage close_2;
  PImage close_3;
  
  PImage medium_1;
  PImage medium_2;
  PImage medium_3;
  
  PImage long_1;
  PImage long_2;
  PImage long_3;

PImage display_1;
PImage display_2;
PImage display_3;

PImage location;
PImage date;
PImage followers;

PImage display;

boolean ir = false;

int minDepth =  60;
int maxDepth = 820;

float deg;

color c1 = #FF0022;
color c2 = #FF00D5;
color c3 = #6900FF;
color blank = #000000;

void setup() {
  frameRate(60);
  size (1280, 1024);
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(depth);
  kinect.enableRGB(rgb);
  kinect.enableIR(ir);
  kinect.tilt(deg);
  
    PImage depthImg = kinect.getDepthImage();

  //kinect.enableIR(ir);
  
  depthImg = new PImage(1280, 800);
  display_1 = new PImage(500, 300);
  display_2 = new PImage(600, 600);
  display_3 = new PImage(200, 100);
  
  location = loadImage("location.png");
  followers = loadImage("followers.png");
  date = loadImage("date.png");
  
  //close_1 = loadImage("close_1.png");
  //close_2 = loadImage("close_2.png");
  //close_3 = loadImage("close_3.png");
  
  //medium_1 = loadImage("medium_1.png");
  //medium_2 = loadImage("medium_2.png");
  //medium_3 = loadImage("medium_3.png");
  
  //long_1 = loadImage("long_1.png");
  //long_2 = loadImage("long_2.png");
  //long_3 = loadImage("long_3.png");
  

  
}

void draw () {
  int[] depth = kinect.getRawDepth();
  PImage depthImg = kinect.getDepthImage();

  //Colour thresholds
  for (int i=0; i < depth.length; i++) {
    if (depth[i] < 720) {
      //display = date;
      //display_1 = close_1;
      //display_2 = close_2; 
      //display_3 = close_3;
      depthImg.pixels[i] = color(c1);


    } else if (depth[i] < 880 && depth[i] > 721) {
      //display = followers;
      //display_1 = medium_1;
      //display_2 = medium_2; 
      //display_3 = medium_3;
      depthImg.pixels[i] = color(c2);


    } else if (depth[i] < 940 && depth[i] > 841) {
      //display = location;
      //display_1 = long_1;
      //display_2 = long_2; 
      //display_3 = long_3;
      depthImg.pixels[i] = color(c3);


    } else {
      depthImg.pixels[i] = color(blank);
      //display = imgBlank;
    }
  }

  //Updating image
  depthImg.updatePixels();
  
  //tint(255,255);
  //image(depthImg, 0, 0);
  //image(kinect.getVideoImage(),640,300);
  tint(255,20);
  //image(display, 0, 0);
  //image(display_2, 250, 250);
  //image(display_3, 350, 100);



  fill(0);
}


void keyPressed() {
  if (key == 'd') {
    depth = !depth;
    kinect.enableDepth(depth);
  } 
  else if (key == 'r') {
    rgb = !rgb;
    if (rgb) ir = false;
    kinect.enableRGB(rgb);
  }
  else if (key == 'i') {
    ir = !ir;
    if (ir) rgb = false;
    kinect.enableIR(ir);
  } 
  else if (key == CODED) {
    if (keyCode == UP) {
      deg++;
    } 
    else if (keyCode == DOWN) {
      deg--;
    }
    deg = constrain(deg,0,30);
    kinect.tilt(deg);
  }
}
void stop() {
  kinect.quit();
  super.stop();
}