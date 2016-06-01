import org.dishevelled.processing.frames.*; //<>// //<>//
import gifAnimation.*;
//maybe introduce a separate thread just for transitions? using timers/switches or variable sets; when draw finishes it sets a flag for some pgraphics object to be drawn or something

import http.requests.*;
import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;

import de.looksgood.ani.*;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import java.net.URL; 
import java.net.URLEncoder;
import java.net.MalformedURLException; 
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLConnection;
import java.nio.charset.Charset;

import java.util.*;
import org.openkinect.*;
import org.openkinect.processing.*;

//Kinect kinect;
//KinectTracker tracker;

Twitter twitter;
URL url;

processing.data.JSONArray locationlist;
String searchString = "#i7226684";
Status currentTweet;
Status newTweet;
User user;

UserTimeCircle userTimeRange1;
UserTimeCircle userTimeRange2;
UserTimeCircle userTimeRange3;
UserTimeCircle userTimeRange4;

UserFollowerCircle userFollowerRange1;
UserFollowerCircle userFollowerRange2;
UserFollowerCircle userFollowerRange3;
UserFollowerCircle userFollowerRange4;

UserLocationCircle userLocationCircle1;

TextCircle textTime1;
TextCircle textTime2;
TextCircle textTime3;
TextCircle textTime4;

TextCircle textFollower1;
TextCircle textFollower2;
TextCircle textFollower3;
TextCircle textFollower4;

Gif fade;

PFont f;
PImage userImage;
PImage userTime;
PImage userFollowers;
PImage userLocation;
PGraphics graphicalMask;

float circleSizeMod;
float iconRadiMod;

int alphavalue = 0;

float count_up;
float count_down;
float calc_alpha;

int widthPosMod = width/2;
int heightPosMod = height/2;

int switchData = 1;

float sizeModLarge = 1;
float sizeModMed = 0.75;
float sizeModSmall = 0.5;
float sizeModXS = 0.25;

boolean depth = true;
boolean rgb = false;
boolean ir = false;

int minDepth =  60;
int maxDepth = 820;
int interval = 7000;

float deg;
String tweetscreen = "TWEET #i7226684 TO ENGAGE";

void setup()
{
  size(1280, 700);
  frameRate(120);
  smooth(8);
  f = createFont("Raleway-ExtraLight.vlw", 32, true);
  textAlign(CENTER);
  ellipseMode(CENTER);

  fade = new Gif(this, "fade.gif");

  //kinect = new Kinect(this);
  //kinect.start();
  println("Camera running");
  //kinect.enableRGB(rgb);
  //kinect.enableIR(ir);
  //kinect.tilt(deg);
  println("Control enabled, UP/DOWN to angle camera");
  //tracker = new KinectTracker();

  ConfigurationBuilder cb = new ConfigurationBuilder();

  cb.setOAuthConsumerKey("GIFUGcFWaxYfjXKZVa31SCZFb");
  cb.setOAuthConsumerSecret("JEJZyQPynIv301QxTcFg31MflLwDSf7Rva5JhdcBVlm1cqzadW");
  cb.setOAuthAccessToken("219294383-Z6qzFAg4DkqphKX1xMq1aOMBTinptMGuIoJW4MGS");
  cb.setOAuthAccessTokenSecret("KQaMQ61idRfkOQoh6PUaArwiP4mA2X8HlNSkh81dABqHn");

  TwitterFactory tf = new TwitterFactory(cb.build());
  twitter = tf.getInstance();

  getNewTweets();
  userTimeRange1 = new UserTimeCircle("https://i7226684.budmd.uk/intimacy/dumper/times.php?start=00:00:00.000000&end=10:00:00.000000", (height * sizeModLarge), width/2, height/2, 32, 60); 
  userTimeRange2 = new UserTimeCircle("https://i7226684.budmd.uk/intimacy/dumper/times.php?start=10:00:01.000000&end=14:00:00.000000", (height * sizeModMed), width/2, height/2, 24, 60); 
  userTimeRange3 = new UserTimeCircle("https://i7226684.budmd.uk/intimacy/dumper/times.php?start=14:00:01.000000&end=18:00:00.000000", (height * sizeModSmall), width/2, height/2, 16, 60); 
  userTimeRange4 = new UserTimeCircle("https://i7226684.budmd.uk/intimacy/dumper/times.php?start=18:00:01.000000&end=23:59:59.000000", (height * sizeModXS), width/2, height/2, 8, 60); 

  userFollowerRange1 = new UserFollowerCircle("https://i7226684.budmd.uk/intimacy/dumper/followers.php?start=0&end=100", (height * sizeModLarge), width/2, height/2, 32, 60); 
  userFollowerRange2 = new UserFollowerCircle("https://i7226684.budmd.uk/intimacy/dumper/followers.php?start=101&end=400", (height * sizeModMed), width/2, height/2, 24, 60); 
  userFollowerRange3 = new UserFollowerCircle("https://i7226684.budmd.uk/intimacy/dumper/followers.php?start=401&end=700", (height * sizeModSmall), width/2, height/2, 16, 60); 
  userFollowerRange4 = new UserFollowerCircle("https://i7226684.budmd.uk/intimacy/dumper/followers.php?start=701&end=2000", (height * sizeModXS), width/2, height/2, 8, 60); 

  userLocationCircle1 = new UserLocationCircle("https://i7226684.budmd.uk/intimacy/dumper/location.php", "https://i7226684.budmd.uk/intimacy/dumper/retrieve.php", (height * sizeModXS), width/2, height/2, 12, 60, ((height * sizeModXS) / 2)); 

  textTime1 = new TextCircle("00:00 - 10:00", (height * sizeModXS) / 2 + 33);
  textTime2 = new TextCircle("10:00 - 14:00", (height * sizeModSmall) / 2 + 33);
  textTime3 = new TextCircle("14:00 - 18:00", (height * sizeModMed) / 2 + 33);
  textTime4 = new TextCircle("18:00 - 00:00", (height * sizeModLarge) / 2 + 33);

  textFollower1 = new TextCircle("0 - 100 FOLLOWERS", (height * sizeModXS) / 2 + 33);
  textFollower2 = new TextCircle("101 - 400 FOLLOWERS", (height * sizeModSmall) / 2 + 33);
  textFollower3 = new TextCircle("401 - 700 FOLLOWERS", (height * sizeModMed) / 2 + 33);
  textFollower4 = new TextCircle("701 - 2000 FOLLOWERS", (height * sizeModLarge) / 2 + 33);

  Ani.init(this);

  thread("refreshTweets");
  //thread("draw");
  println("Thread running - user tracking");
  //thread("mousePressed");
  //thread("dump");
  getNewTweets();
  background(0);
}

void draw()
{

  //if (keyPressed) {
  //  if (key == '1') {
  //    switchData = 1;
  //  } else if (key == '2') {
  //    switchData = 2;
  //  } else if (key == '3') {
  //    switchData = 3;
  //  } else if (key == '4') {
  //    switchData = 4;
  //  }
  //}


  if (switchData == 1) {
    fader(1000, 1);
    return;
  } else if (switchData == 2) {
    fader(1000, 2);
    return;
  } else if (switchData == 3) {
    fader(1000, 3);
    return;
  } else if (switchData == 4) { 
    fader(1000, 4);
    return;
  }
  fill(0, alphavalue);
  rect(0, 0, width, height);
}

void fader(int duration, int function) {


  if (function == 1) {
    tweetScreen();
    return;
  } else if (function == 2) {
    userTimeRange();
    return;
  } else if (function == 3) {
    userFollowerRange();
    return;
  } else if (function == 4) {
    userLocationRange();
    return;
  }
}

void userLocationRange() {
  userLocationCircle1.buildUserRange();
  return;
}

void userTimeRange() {
  //translate(width/2, height/2);
  fade();
  ellipseMode(CENTER);
  background(0);
  noFill();
  stroke(153);
  ellipse(width/2, height/2, (height * sizeModLarge), (height * sizeModLarge));
  ellipse(width/2, height/2, (height * sizeModMed), (height * sizeModMed));
  ellipse(width/2, height/2, (height * sizeModSmall), (height * sizeModSmall));
  ellipse(width/2, height/2, (height * sizeModXS), (height * sizeModXS));
  userTimeRange1.buildRange();
  userTimeRange2.buildRange();
  userTimeRange3.buildRange();
  userTimeRange4.buildRange();
  //translate(width/2, height/2);
  textTime1.buildText();
  textTime2.buildText();
  textTime3.buildText();
  textTime4.buildText();
  return;
}

void fade()
{
  fade.play();
  image(fade, 0, 0);
}

void userFollowerRange() {
  ellipseMode(CENTER);
  background(0);
  noFill();
  stroke(153);
  ellipse(width/2, height/2, (height * sizeModLarge), (height * sizeModLarge));
  ellipse(width/2, height/2, (height * sizeModMed), (height * sizeModMed));
  ellipse(width/2, height/2, (height * sizeModSmall), (height * sizeModSmall));
  ellipse(width/2, height/2, (height * sizeModXS), (height * sizeModXS));
  userFollowerRange1.buildRange();
  userFollowerRange2.buildRange();
  userFollowerRange3.buildRange();
  userFollowerRange4.buildRange();
  textFollower1.buildText();
  textFollower2.buildText();
  textFollower3.buildText();
  textFollower4.buildText();
  return;
}


void getNewTweets()
{
  try
  {
    println("Initialising...");

    Query query = new Query(searchString);
    QueryResult result = twitter.search(query);
    currentTweet = result.getTweets().get(0);
    user = currentTweet.getUser();
  }
  catch (TwitterException te)
  {
    System.out.println("Failed to search tweets: " + te.getMessage());
    System.exit(-1);
  }
}

void refreshTweets() {
  while (true) {
    //tracker.track();
    if (millis() > interval) {
      try
      {
        if (millis() > interval) {
          Query query = new Query(searchString);
          QueryResult result = twitter.search(query);
          newTweet = result.getTweets().get(0);
          println(currentTweet.getText());
          println(newTweet.getText());
          interval += 7000;

          if (currentTweet.getText().equals(newTweet.getText()) == true) {
            println("No New Tweets");
          } else {
            println("New Tweet Found");
            currentTweet = newTweet;
            user = currentTweet.getUser();
            println("Focus currentTweet Updated");
            dump();
          }
        } else {
          println("Interval not reached, waiting " + interval + "ms");
        }
      }
      catch (TwitterException te)
      {
        System.out.println("Failed to search tweets: " + te.getMessage());
        System.exit(-1);
      }

      println("Updated Tweets");
    }
  }
}

void dump() {

  DateFormat df = new SimpleDateFormat("HH:mm:ss");  
  Date tweetTime = currentTweet.getCreatedAt(); 
  String reportDate = df.format(tweetTime);
  currentTweet.getUser();
  user.getLocation();
  user.getFollowersCount();
  currentTweet.getText();
  currentTweet.getCreatedAt();

  String profile = user.getBiggerProfileImageURL();

  userImage = loadImage(profile, "png");

  String name = user.getScreenName();
  String location = user.getLocation();
  int followers = user.getFollowersCount();
  String tweet = currentTweet.getText();

  tweet = tweet.replaceAll("'", "");
  profile = profile.replaceAll("'", "");

  String encodedTweet = URLEncoder.encode(tweet);
  String encodedImg = URLEncoder.encode(profile);
  String encodedTime = URLEncoder.encode(reportDate);
  String encodedName = URLEncoder.encode(name);
  String encodedLocation = URLEncoder.encode(location);

  GetRequest get = new GetRequest("https://i7226684.budmd.uk/intimacy/dumper/?" + "screename=" + encodedName + "&location=" + encodedLocation + "&followers=" + followers + "&tweet=" + encodedTweet + "&img=" + encodedImg + "&time=" + encodedTime);
  get.send();
  println("https://i7226684.budmd.uk/intimacy/dumper/?" + "screename=" + encodedName + "&location=" + encodedLocation + "&followers=" + followers + "&tweet=" + encodedTweet + "&img=" + encodedImg + "&time=" + encodedTime);
  println("Dumped");
}

void tweetScreen() {
  background(0);
  noFill();
  stroke(153);
  float line = 0;
  int fontXPos = 10;
  ellipse(width/2, height/2, (height * sizeModLarge), (height * sizeModLarge));

  // Display the character
  fill(255);
  textSize(22);

  translate(width/4 + 70, height/2);

  for (int i = 0; i < tweetscreen.length(); i++) {
    text(tweetscreen.charAt(i), fontXPos, 0);
    fontXPos += 20;
  }
  return;
}

void mousePressed() {
  currentTweet.getUser();
  user.getLocation();
  user.getFollowersCount();
  currentTweet.getText();
  currentTweet.getCreatedAt();

  String profile = user.getBiggerProfileImageURL();

  userImage = loadImage(profile, "png");

  String name = user.getScreenName();
  String location = user.getLocation();
  int followers = user.getFollowersCount();
  String tweet = currentTweet.getText();

  tweet = tweet.replaceAll("'", "");
  profile = profile.replaceAll("'", "");

  String encodedTweet = URLEncoder.encode(tweet);
  String encodedImg = URLEncoder.encode(profile);

  switchData++;  

  //--- DEVELOPMENT CODE GOES BELOW--
}

//void keyPressed() {
//  if (key == 'd') {
//    depth = !depth;
//    kinect.enableDepth(depth);
//  } else if (key == 'r') {
//    rgb = !rgb;
//    if (rgb) ir = false;
//    kinect.enableRGB(rgb);
//  } else if (key == 'i') {
//    ir = !ir;
//    if (ir) rgb = false;
//    kinect.enableIR(ir);
//  } else if (key == CODED) {
//    if (keyCode == UP) {
//      deg++;
//    } else if (keyCode == DOWN) {
//      deg--;
//    }
//    deg = constrain(deg, 0, 30);
//    kinect.tilt(deg);
//  }
//}