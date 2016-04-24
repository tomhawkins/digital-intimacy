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

String searchString = "#i7226684";
Status currentTweet;
Status newTweet;
User user;
PFont f;
PImage userImage;

void setup()
{
  size(800, 600, P2D);
  smooth(8);
  f = createFont("Raleway-ExtraLight.vlw", 32, true);
  textAlign(CENTER);
  rectMode(CENTER);
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

  DateFormat df = new SimpleDateFormat("dd/MM" + " - " + "hh:mm:ss");  
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

  GetRequest get = new GetRequest("https://i7226684.budmd.uk/intimacy/dumper/?" + "screename=" + name + "&location=" + location + "&followers=" + followers + "&tweet=" + encodedTweet + "&img=" + encodedImg);
  get.send();
  println("https://i7226684.budmd.uk/intimacy/dumper/?" + "screename=" + name + "&location=" + location + "&followers=" + followers + "&tweet=" + encodedTweet + "&img=" + encodedImg);
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

  GetRequest get = new GetRequest("https://i7226684.budmd.uk/intimacy/dumper/retrieve.php/?" + "&location=" + location);
  get.send();
  println("https://i7226684.budmd.uk/intimacy/dumper/retrieve.php/?" + "&location=" + location);
  get.addHeader("Accept", "application/json");
  println("Request sent");

  String object = get.getContent();

  processing.data.JSONArray values = processing.data.JSONArray.parse(object);

  //println("Reponse Content: " + values);

  //processing.data.JSONObject values = json.getJSONObject("entries");
  textLeading(50);
  for (int i = 0, s = 0; i < values.size(); i++, s++) {

    processing.data.JSONObject entry = values.getJSONObject(i); 

    String entry_location = entry.getString("intimacy_location");
    String entry_image = entry.getString("intimacy_img");
    println(entry_image + ", " + entry_location);
    textSize(16);
    text((entry_location), 100, s+=60);
    image(userImage, 50, s+=30);
    redraw();
  }
}