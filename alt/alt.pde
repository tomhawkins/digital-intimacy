import http.requests.*; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//

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
//import org.openkinect.*;
//import org.openkinect.processing.*;

//Kinect kinect;

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
int switchData = 0;
float sizeModLarge = 1;
float sizeModMed = 0.75;
float sizeModSmall = 0.5;
float sizeModXS = 0.25;

boolean depth = true;
boolean rgb = false;
boolean ir = false;

int minDepth =  60;
int maxDepth = 820;

float deg;

void setup()
{
  size(1280, 700);
  frameRate(60);
  smooth(8);
  f = createFont("Raleway-ExtraLight.vlw", 32, true);
  textAlign(CENTER);
  ellipseMode(CENTER);

  //kinect = new Kinect(this);
  //kinect.start();
  //kinect.enableDepth(depth);
  //kinect.enableRGB(rgb);
  //kinect.enableIR(ir);
  //kinect.tilt(deg);

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
  userFollowerRange4 = new UserFollowerCircle("https://i7226684.budmd.uk/intimacy/dumper/followers.php?start=1000&end=2000", (height * sizeModXS), widthPosMod, heightPosMod, 9, 60); 

  userLocationCircle1 = new UserLocationCircle("https://i7226684.budmd.uk/intimacy/dumper/location.php", "https://i7226684.budmd.uk/intimacy/dumper/retrieve.php", (height * sizeModXS), widthPosMod, heightPosMod, 9, 60); 

  textTime1 = new TextCircle("00:00 - 10:00", (height * sizeModXS) / 2 + 33);
  textTime2 = new TextCircle("10:00 - 14:00", (height * sizeModSmall) / 2 + 33);
  textTime3 = new TextCircle("14:00 - 18:00", (height * sizeModMed) / 2 + 33);
  textTime4 = new TextCircle("18:00 - 00:00", (height * sizeModLarge) / 2 + 33);

  thread("refreshTweets");
  //thread("userTimeRange");
  //thread("mousePressed");
  //thread("dump");
  getNewTweets();
  background(0);
}

void draw()
{

  //kinectControl();
  //refreshTweets();

  userTimeRangeBackground();
  userTimeRange();

  //userFollowerRangeBackground();
  //userFollowerRange();

  //userLocationRange();
  translate(628, 338);
  textTime1.buildText();
  textTime2.buildText();
  textTime3.buildText();
  textTime4.buildText();

  //dump();
  //getTweet();
  //getDetails();
  //getImage();
  //getScreenName();
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
}

void userFollowerRange() {
  userFollowerRange1.buildRange();
  userFollowerRange2.buildRange();
  userFollowerRange3.buildRange();
  userFollowerRange4.buildRange();
}

//void kinectControl() {
//  int[] depth = kinect.getRawDepth();
//  //Colour thresholds
//  for (int i=0; i < depth.length; i++) {
//   if (depth[i] < 900) {
//     println("Case 0 switch");
//     switchData = 1;
//     break;
//   } else if (depth[i] < 1200 && depth[i] > 901) {
//     println("Case 1 switch");
//     switchData = 2;
//     break;
//   } else if (depth[i] < 1600 && depth[i] > 1201) {
//     switchData = 3;
//     println("Case 2 switch");
//     break;
//   } else {
//     switchData = 4;
//     println("Case 3 switch");
//     break;
//   }
//  }

//  if (switchData == 1) {
//   userFollowerRangeBackground();
//   userFollowerRange();
//  } else if (switchData == 2) {
//   userTimeRangeBackground();
//   userTimeRange();
//  } else if (switchData == 3) {
//   println("switchData is 3");
//  } else {
//   println("switchData is 4");
//   userTimeRangeBackground();
//   userTimeRange();
//  }

//  //take logic from kinect prototype... if/else, and, if depth range 1, then int switch = 0, depth range 2, int switch = 1, range 3, int switch = 2, etc
//  //each switch changes the data visualisation being shown

//  switch(switchData) {
//  case 0: 
//  userFollowerRangeBackground();
//  userFollowerRange();
//  break;
//  case 1: 
//  userTimeRangeBackground();
//  userTimeRange();
//  break;
//  case 2:
//  //userLocationBackground();
//  //userLocation();
//  println("Case 2 switch");
//  break;
//  case 3:
//  //userLocationBackground();
//  //userLocation();
//  println("Case 3 switch");
//  }
//}

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

void refreshTweets()

{
  try
  {
    //println(currentTweet.getText());

    Query query = new Query(searchString);
    QueryResult result = twitter.search(query);

    newTweet = result.getTweets().get(0);

    println(currentTweet.getText());
    println(newTweet.getText());

    if (currentTweet.getText().equals(newTweet.getText()) == true) {
      println("No New Tweets");
    } else {
      println("New Tweet Found");
      currentTweet = newTweet;
      user = currentTweet.getUser();
      println("Focus currentTweet Updated");
      dump();
    }
  }
  catch (TwitterException te)
  {
    System.out.println("Failed to search tweets: " + te.getMessage());
    System.exit(-1);
  }

  println("Updated Tweets");
}


void getScreenName()
{

  currentTweet.getUser();
  user.getLocation();
  user.getFollowersCount();
  currentTweet.getText();
  currentTweet.getCreatedAt();

  println(user.getScreenName());
  println(user.getLocation());
  println(user.getFollowersCount() + " followers");
  println(currentTweet.getText());
  println(currentTweet.getCreatedAt());
}

void getTweet()
{
  String userTweet = currentTweet.getText();
  text(userTweet, (width/2), 300, 700, 250);
  redraw();
}

void getDetails()
{

  DateFormat df = new SimpleDateFormat("HH:mm:ss");  
  Date tweetTime = currentTweet.getCreatedAt();   

  String userName = user.getScreenName();
  String userLocation = user.getLocation();
  int userFollowers = user.getFollowersCount();
  String reportDate = df.format(tweetTime);
  String profile = user.getBiggerProfileImageURL();

  userImage = loadImage(profile, "png");

  text("@" + userName, (width/2), 350);
  text(userLocation, (width/2), 400, 200);
  text(userFollowers + " followers", (width/2), 450);
  text(reportDate, width/2, 500);
  image(userImage, width/2, 100);
  redraw();
}

void getImage()
{
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