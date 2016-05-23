//class KinectTracker {



//  // Size of kinect image
//  int kw = 640;
//  int kh = 480;

//  int case1ThresholdEnter = 330;
//  int case1ThresholdExit = 780;

//  int case2ThresholdEnter = 781;
//  int case2ThresholdExit = 880;

//  int case3ThresholdEnter = 881;
//  int case3ThresholdExit = 940;

//  int case4ThresholdEnter = 941;
//  int case4ThresholdExit = 1000;

//  // Raw location
//  PVector loc;

//  // Interpolated location
//  PVector lerpedLoc;

//  // Depth data
//  int[] depth;


//  PImage display;

//  KinectTracker() {
//    kinect.start();
//    kinect.enableDepth(true);

//    // We could skip processing the grayscale image for efficiency
//    // but this example is just demonstrating everything
//    kinect.processDepthImage(true);

//    display = createImage(kw, kh, PConstants.RGB);

//    loc = new PVector(0, 0);
//    lerpedLoc = new PVector(0, 0);
//  }

//  void track() {

//    // Get the raw depth as array of integers
//    depth = kinect.getRawDepth();

//    // Being overly cautious here
//    if (depth == null) return;

//    float sum1X = 0;
//    float sum1Y = 0;
//    float count1 = 0;

//    float sum2X = 0;
//    float sum2Y = 0;
//    float count2 = 0;

//    float sum3X = 0;
//    float sum3Y = 0;
//    float count3 = 0;

//    float sum4X = 0;
//    float sum4Y = 0;
//    float count4 = 0;    


//    for (int x = 0; x < kw; x++) {
//      for (int y = 0; y < kh; y++) {
//        // Mirroring the image
//        int offset = kw-x-1+y*kw;
//        // Grabbing the raw depth
//        int rawDepth = depth[offset];

//        // Testing against threshold
//        if (rawDepth < case1ThresholdExit) {
//          sum1X += x;
//          sum1Y += y;
//          count1++;
//        } else if (rawDepth < case2ThresholdExit && rawDepth > case2ThresholdEnter) {
//          sum2X += x;
//          sum2Y += y;
//          count2++;
//        } else if (rawDepth < case3ThresholdExit && rawDepth > case3ThresholdEnter) {
//          sum3X += x;
//          sum3Y += y;
//          count3++;
//        } else {
//          sum4X += x;
//          sum4Y += y;
//          count4++;
//        }
//      }
//    }
//    // As long as we found something
//    if (count1 != 0) {
//      loc = new PVector(sum1X/count1, sum1Y/count1);
//      userTimeRangeBackground();
//      userTimeRange();
//    } else if (count2 != 0) {
//      loc = new PVector(sum2X/count2, sum2Y/count2);
//      userFollowerRangeBackground();
//      userFollowerRange();
//    } else if (count3 != 0) {
//      loc = new PVector(sum3X/count3, sum3Y/count3);
//      userLocationRange();
//    } else if (count4 != 0) {
//      loc = new PVector(sum4X/count4, sum4Y/count4);
//      ellipse(height/2, width/2, 200, 200);
//    } else {
//    }

//    //else {
//    //  ellipse(height/2, width/2, 0, 0);

//    //// Interpolating the location, doing it arbitrarily for now
//    lerpedLoc.x = PApplet.lerp(lerpedLoc.x, loc.x, 0.3f);
//    lerpedLoc.y = PApplet.lerp(lerpedLoc.y, loc.y, 0.3f);
//  }

//  PVector getLerpedPos() {
//    return lerpedLoc;
//  }

//  PVector getPos() {
//    return loc;
//  }

//  void display() {
//    PImage img = kinect.getDepthImage();

//    // Being overly cautious here
//    if (depth == null || img == null) return;

//    // Going to rewrite the depth image to show which pixels are in threshold
//    // A lot of this is redundant, but this is just for demonstration purposes
//    display.loadPixels();
//    for (int x = 0; x < kw; x++) {
//      for (int y = 0; y < kh; y++) {
//        // mirroring image
//        int offset = kw-x-1+y*kw;
//        // Raw depth
//        int rawDepth = depth[offset];

//        int pix = x+y*display.width;
//        if (rawDepth < case1ThresholdExit && rawDepth > case1ThresholdEnter) {
//          // A red color instead
//          display.pixels[pix] = color(150, 50, 50);
//        } else if (rawDepth < case2ThresholdExit && rawDepth > case2ThresholdEnter) {
//          // A red color instead
//          display.pixels[pix] = color(100, 23, 50);
//        } else if (rawDepth < case3ThresholdExit && rawDepth > case3ThresholdEnter) {
//          // A red color instead
//          display.pixels[pix] = color(50, 110, 50);
//        } else if (rawDepth < case4ThresholdExit && rawDepth > case4ThresholdEnter) {
//          display.pixels[pix] = color(20, 93, 12);
//        } else {

//          display.pixels[pix] = img.pixels[offset];
//        }
//      }
//    }
//    display.updatePixels();

//    // Draw the image
//    image(display, 0, 0);
//  }

//  void quit() {
//    kinect.quit();
//  }

//  int getThreshold() {
//    return case1ThresholdExit;
//  }

//  void setThreshold(int t) {
//    case1ThresholdExit =  t;
//  }
//}