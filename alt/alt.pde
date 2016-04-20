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

  //thread("refreshTweets");
}

void draw()
{
  textFont(f);
  fill(255);
  background(0);
  println("not locked");
  getScreenName();
  getTweet();
  getDetails();
  getImage();
  delay(7000);
  refreshTweets();
}

void getNewTweets()
{
  try
  {
    println("Getting Tweet");
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
  delay(7000);
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
}

void getDetails()
{

  DateFormat df = new SimpleDateFormat("dd/MM" + " - " + "hh:mm:ss");  
  Date tweetTime = currentTweet.getCreatedAt();   

  String userName = user.getScreenName();
  String userLocation = user.getLocation();
  int userFollowers = user.getFollowersCount();
  String reportDate = df.format(tweetTime);

  text("@" + userName, (width/2), 350);
  text(userLocation, (width/2), 400, 200);
  text(userFollowers + " followers", (width/2), 450);
  text(reportDate, width/2, 500);
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

  String name = user.getScreenName();
  String location = user.getLocation();
  int followers = user.getFollowersCount();
  String tweet = currentTweet.getText();

  String encodedTweet = URLEncoder.encode(tweet);

  GetRequest get = new GetRequest("https://i7226684.budmd.uk/intimacy/dumper/?" + "screename=" + name + "&location=" + location + "&followers=" + followers + "&tweet=" + encodedTweet);
  get.send();
  println("https://i7226684.budmd.uk/intimacy/dumper/?" + "screename=" + name + "&location=" + location + "&followers=" + followers + "&tweet=" + encodedTweet);
  println("Dumped");
}

void mousePressed() {

  currentTweet.getUser();
  user.getLocation();
  user.getFollowersCount();
  currentTweet.getText();
  currentTweet.getCreatedAt();

  String name = user.getScreenName();
  String location = user.getLocation();
  int followers = user.getFollowersCount();
  String tweet = currentTweet.getText();

  String encodedTweet = URLEncoder.encode(tweet);

  GetRequest get = new GetRequest("https://i7226684.budmd.uk/intimacy/dumper/retrieve.php?" + "screename=" + name + "&location=" + location);
  get.send();
  println("https://i7226684.budmd.uk/intimacy/dumper/retrieve.php?" + "screename=" + name + "&location=" + location);
  get.addHeader("Accept", "application/json");
  println("Request sent");

  String object = get.getContent();

  processing.data.JSONArray values = processing.data.JSONArray.parse(object);

  //println("Reponse Content: " + values);

  //processing.data.JSONObject values = json.getJSONObject("entries");

  for (int i = 0; i < values.size(); i++) {
    for (int s = 50; s < values.size(); s+=50) {

      processing.data.JSONObject entry = values.getJSONObject(i); 

      int entry_id = entry.getInt("intimacy_id");
      String entry_screename = entry.getString("intimacy_screename");
      String entry_location = entry.getString("intimacy_location");

      println(entry_screename + ", " + entry_location);
      text((entry_screename + ", " + entry_location), 300, s);
    }
  }
}