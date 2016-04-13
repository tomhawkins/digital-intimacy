import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import java.util.*;

Twitter twitter;

String searchString = "#i7226684";
int currentTweet;
List<Status> tweets;
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
  //user = twitter.getScreenName();


  currentTweet = 0;

  getNewTweets();

  thread("refreshTweets");
}

void draw()
{
  textFont(f);
  fill(255);
  getScreenName();
  background(0);
  getDate();
  getTweet();
  getDetails();
  getImage();
}

void getNewTweets()
{
  try
  {
    Query query = new Query(searchString);
    QueryResult result = twitter.search(query);
    tweets = result.getTweets();
  }
  catch (TwitterException te)
  {
    System.out.println("Failed to search tweets: " + te.getMessage());
    System.exit(-1);
  }
}

void getScreenName()
{
  Status status = tweets.get(currentTweet);
  User user = status.getUser();

  status.getUser();
  user.getLocation();
  user.getFollowersCount();
  status.getText();
  status.getCreatedAt();

  println(user.getScreenName());
  println(user.getLocation());
  println(user.getFollowersCount() + " followers");
  println(status.getText());
  println(status.getCreatedAt());
}

void refreshTweets()
{
  while (true)
  {
    getNewTweets();

    println("Updated Tweets");

    delay(10000);
  }
}

void getDate()
{
  Status status = tweets.get(currentTweet);
  User user = status.getUser();

  // Create an instance of SimpleDateFormat used for formatting 
  // the string representation of date (month/day/year)
  DateFormat df = new SimpleDateFormat("dd/MM" + " - " + "hh:mm:ss");

  // Get the date today using Calendar object.
  //Date tweetTime = Calendar.getInstance().getTime();   
  Date tweetTime = status.getCreatedAt();   
  // Using DateFormat format method we can create a string 
  // representation of a date with the defined format.
  String reportDate = df.format(tweetTime);

  text(reportDate, width/2, 500);
}

void getTweet()
{
  Status status = tweets.get(currentTweet);
  User user = status.getUser();

  String userTweet = status.getText();
  text(userTweet, (width/2), 300, 700, 250);
}

void getDetails()
{
  Status status = tweets.get(currentTweet);
  User user = status.getUser();

  String userName = user.getScreenName();
  String userLocation = user.getLocation();
  int userFollowers = user.getFollowersCount();

  text("@" + userName, (width/2), 350);
  text(userLocation, (width/2), 400, 200);
  text(userFollowers + " followers", (width/2), 450);
}

void getImage()
{
}