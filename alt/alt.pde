//maybe introduce a separate thread just for transitions? using timers/switches or variable sets; when draw finishes it sets a flag for some pgraphics object to be drawn or something //<>//

import http.requests.*;
import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;

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

Kinect kinect;
KinectTracker tracker;

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

PFont f;
PImage userImage;
PImage userTime;
PImage userFollowers;
PImage userLocation;
PGraphics graphicalMask;

float circleSizeMod;
float iconRadiMod;

int widthPosMod = 600;
int heightPosMod = 310;
int switchData = 4;
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

  kinect = new Kinect(this);
  //kinect.start();
  println("Camera running");
  //kinect.enableRGB(rgb);
  //kinect.enableIR(ir);
  //kinect.tilt(deg);
  println("Control enabled, UP/DOWN to angle camera");
  tracker = new KinectTracker();

  ConfigurationBuilder cb = new ConfigurationBuilder();

  cb.setOAuthConsumerKey("GIFUGcFWaxYfjXKZVa31SCZFb");
  cb.setOAuthConsumerSecret("JEJZyQPynIv301QxTcFg31MflLwDSf7Rva5JhdcBVlm1cqzadW");
  cb.setOAuthAccessToken("219294383-Z6qzFAg4DkqphKX1xMq1aOMBTinptMGuIoJW4MGS");
  cb.setOAuthAccessTokenSecret("KQaMQ61idRfkOQoh6PUaArwiP4mA2X8HlNSkh81dABqHn");

  TwitterFactory tf = new TwitterFactory(cb.build());
  twitter = tf.getInstance();

  getNewTweets();
  userTimeRange1 = new UserTimeCircle("https://i7226684.budmd.uk/intimacy/dumper/times.php?start=00:00:00.000000&end=10:00:00.000000", (height * sizeModLarge), widthPosMod, heightPosMod, 30, 60); 
  userTimeRange2 = new UserTimeCircle("https://i7226684.budmd.uk/intimacy/dumper/times.php?start=10:00:01.000000&end=14:00:00.000000", (height * sizeModMed), widthPosMod, heightPosMod, 40, 60); 
  userTimeRange3 = new UserTimeCircle("https://i7226684.budmd.uk/intimacy/dumper/times.php?start=14:00:01.000000&end=18:00:00.000000", (height * sizeModSmall), widthPosMod, heightPosMod, 60, 60); 
  userTimeRange4 = new UserTimeCircle("https://i7226684.budmd.uk/intimacy/dumper/times.php?start=18:00:01.000000&end=23:59:59.000000", (height * sizeModXS), widthPosMod, heightPosMod, 9, 60); 

  userFollowerRange1 = new UserFollowerCircle("https://i7226684.budmd.uk/intimacy/dumper/followers.php?start=0&end=100", (height * sizeModLarge), widthPosMod, heightPosMod, 30, 60); 
  userFollowerRange2 = new UserFollowerCircle("https://i7226684.budmd.uk/intimacy/dumper/followers.php?start=101&end=400", (height * sizeModMed), widthPosMod, heightPosMod, 40, 60); 
  userFollowerRange3 = new UserFollowerCircle("https://i7226684.budmd.uk/intimacy/dumper/followers.php?start=401&end=700", (height * sizeModSmall), widthPosMod, heightPosMod, 60, 60); 
  userFollowerRange4 = new UserFollowerCircle("https://i7226684.budmd.uk/intimacy/dumper/followers.php?start=701&end=2000", (height * sizeModXS), widthPosMod, heightPosMod, 9, 60); 

  userLocationCircle1 = new UserLocationCircle("https://i7226684.budmd.uk/intimacy/dumper/location.php", "https://i7226684.budmd.uk/intimacy/dumper/retrieve.php", (height * sizeModXS), widthPosMod, heightPosMod, 9, 60, "Bournemouth", (height * sizeModXS)); 

  textTime1 = new TextCircle("00:00 - 10:00", (height * sizeModXS) / 2 + 33);
  textTime2 = new TextCircle("10:00 - 14:00", (height * sizeModSmall) / 2 + 33);
  textTime3 = new TextCircle("14:00 - 18:00", (height * sizeModMed) / 2 + 33);
  textTime4 = new TextCircle("18:00 - 00:00", (height * sizeModLarge) / 2 + 33);

  textFollower1 = new TextCircle("0 - 100 FOLLOWERS", (height * sizeModXS) / 2 + 33);
  textFollower2 = new TextCircle("101 - 400 FOLLOWERS", (height * sizeModSmall) / 2 + 33);
  textFollower3 = new TextCircle("401 - 700 FOLLOWERS", (height * sizeModMed) / 2 + 33);
  textFollower4 = new TextCircle("701 - 2000 FOLLOWERS", (height * sizeModLarge) / 2 + 33);

  thread("refreshTweets");
  println("Thread running - user tracking");
  //thread("mousePressed");
  //thread("dump");
  getNewTweets();
  background(0);
}

void draw()
{
  //background(0);
  fill(0, 150);
  rect(0, 0, width, height);
  //fill(0);
  if (switchData == 1) {
    tweetScreen();
  } else if (switchData == 2) {
    userTimeRangeBackground();
    userTimeRange();
  } else if (switchData == 3) {
    userFollowerRangeBackground();
    userFollowerRange();
  } else if (switchData == 4) { 
    userLocationRange();
  }
}

void userLocationRange() {
  userLocationCircle1.buildUserRange();
}

void userTimeRangeBackground() {
  background(0);
  noFill();
  stroke(153);
  ellipse(628, 338, (height * sizeModLarge), (height * sizeModLarge));
  ellipse(628, 338, (height * sizeModMed), (height * sizeModMed));
  ellipse(628, 338, (height * sizeModSmall), (height * sizeModSmall));
  ellipse(628, 338, (height * sizeModXS), (height * sizeModXS));
}

void userFollowerRangeBackground() {
  noFill();
  stroke(153);
  ellipse(628, 338, (height * sizeModLarge), (height * sizeModLarge));
  ellipse(628, 338, (height * sizeModMed), (height * sizeModMed));
  ellipse(628, 338, (height * sizeModSmall), (height * sizeModSmall));
  ellipse(628, 338, (height * sizeModXS), (height * sizeModXS));
}

void userTimeRange() {
  userTimeRange1.buildRange();
  userTimeRange2.buildRange();
  userTimeRange3.buildRange();
  userTimeRange4.buildRange();
  translate(628, 338);
  textTime1.buildText();
  textTime2.buildText();
  textTime3.buildText();
  textTime4.buildText();
}

void userFollowerRange() {
  userFollowerRange1.buildRange();
  userFollowerRange2.buildRange();
  userFollowerRange3.buildRange();
  userFollowerRange4.buildRange();
  translate(628, 338);
  textFollower1.buildText();
  textFollower2.buildText();
  textFollower3.buildText();
  textFollower4.buildText();
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
    tracker.track();
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
  int fontXPos = 388;
  ellipse(628, 338, (height * sizeModLarge), (height * sizeModLarge));

  // Display the character
  fill(255);
  textSize(22);

  for (int i = 0; i < tweetscreen.length(); i++) {
    text(tweetscreen.charAt(i), fontXPos, 338);
    fontXPos += 20;
  }
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

  //--- DEVELOPMENT CODE GOES BELOW--
}

void keyPressed() {
  if (key == 'd') {
    depth = !depth;
    kinect.enableDepth(depth);
  } else if (key == 'r') {
    rgb = !rgb;
    if (rgb) ir = false;
    kinect.enableRGB(rgb);
  } else if (key == 'i') {
    ir = !ir;
    if (ir) rgb = false;
    kinect.enableIR(ir);
  } else if (key == CODED) {
    if (keyCode == UP) {
      deg++;
    } else if (keyCode == DOWN) {
      deg--;
    }
    deg = constrain(deg, 0, 30);
    kinect.tilt(deg);
  }
}