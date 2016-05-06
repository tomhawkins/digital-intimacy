import http.requests.*; //<>// //<>//

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

Twitter twitter;
URL url;

processing.data.JSONArray locationlist;
String searchString = "#i7226684";
Status currentTweet;
Status newTweet;
User user;
PFont f;
PImage userImage;

float posX, posY;
float radiusX, radiusY;
float theta;
float i;

PImage userTime;

void setup()
{
  size(800, 600, P2D);
  smooth(8);
  f = createFont("Raleway-ExtraLight.vlw", 32, true);
  textAlign(CENTER);
  rectMode(CENTER);

  posX = posY = 0;

  radiusX = 200;
  radiusY = 200;

  theta = 0;

  ConfigurationBuilder cb = new ConfigurationBuilder();

  cb.setOAuthConsumerKey("GIFUGcFWaxYfjXKZVa31SCZFb");
  cb.setOAuthConsumerSecret("JEJZyQPynIv301QxTcFg31MflLwDSf7Rva5JhdcBVlm1cqzadW");
  cb.setOAuthAccessToken("219294383-Z6qzFAg4DkqphKX1xMq1aOMBTinptMGuIoJW4MGS");
  cb.setOAuthAccessTokenSecret("KQaMQ61idRfkOQoh6PUaArwiP4mA2X8HlNSkh81dABqHn");

  TwitterFactory tf = new TwitterFactory(cb.build());
  twitter = tf.getInstance();

  getNewTweets();

  thread("refreshTweets");
  //thread("mousePressed");
  thread("dump");
}

void draw()
{
  textFont(f);
  fill(255);
  background(0);

  refreshTweets();
  //dump();
  //listUsers();
  getTweet();
  getDetails();
  getImage();
  getScreenName();
  delay(7000);
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

  DateFormat df = new SimpleDateFormat("hh:mm:ss");  
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

  GetRequest get = new GetRequest("https://i7226684.budmd.uk/intimacy/dumper/?" + "screename=" + name + "&location=" + location + "&followers=" + followers + "&tweet=" + encodedTweet + "&img=" + encodedImg + "&time=" + encodedTime);
  get.send();
  println("https://i7226684.budmd.uk/intimacy/dumper/?" + "screename=" + name + "&location=" + location + "&followers=" + followers + "&tweet=" + encodedTweet + "&img=" + encodedImg + "&time=" + encodedTime);
  println("Dumped");
}

void listUsers() {

  GetRequest get = new GetRequest("https://i7226684.budmd.uk/intimacy/dumper/index.php");
  GetRequest locationRequest = new GetRequest("https://i7226684.budmd.uk/intimacy/dumper/retrieve.php");
  get.send();
  locationRequest.send();
  get.addHeader("Accept", "application/json");
  println("Request sent");

  processing.data.JSONObject values = processing.data.JSONObject.parse(get.getContent());
  processing.data.JSONArray locArray = processing.data.JSONArray.parse(locationRequest.getContent());

  for (int i = 0; i < locArray.size(); i++) {
    processing.data.JSONObject locObject = locArray.getJSONObject(i);
    String locString = locObject.getString("intimacy_location");
    println("Location: " + locString + "\n Users:");
    processing.data.JSONArray currentLoc = values.getJSONArray(locString);

    for (int ii = 0; ii < currentLoc.size(); ii++) {

      String user = currentLoc.getString(ii);
      println(user);
    }
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

  GetRequest get = new GetRequest("https://i7226684.budmd.uk/intimacy/dumper/times.php?start=01:00:00.000000&end=03:00:00.000000");
  get.send();
  get.addHeader("Accept", "application/json");
  println("Request sent");
  
  background( 0 );
  translate( width / 2, height / 2 );
  fill( 255 );
  
  processing.data.JSONArray values = processing.data.JSONArray.parse(get.getContent());

  for (int i = 0; i < values.size(); i++) {
    processing.data.JSONObject timesObject = values.getJSONObject(i);
    String imgURL = timesObject.getString("intimacy_img");
    //println(imgURL);
    
      userTime = loadImage(imgURL);
      theta+=30;
      image(userTime, radiusX * cos(theta), radiusY * sin(theta), 50, 50); 
      //ellipse( radiusX * cos(theta), radiusY * sin(theta), 30, 30 );

  }
}