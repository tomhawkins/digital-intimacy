//import and generate Semaphores
import java.util.concurrent.Semaphore;
static Semaphore semaphoreExample = new Semaphore( 1 );  
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
/*
  Semaphores are locks that lock specific parts of code so only a specific amount of Threads can enter the code.
 You can use them for critical parts of code.
 Semaphores who allow only one thread to enter are called a Mutex.
 */

//graphics object we will use to buffer our drawing
PGraphics graphics;


int lastCallLogic = 0; //absolute time when logic thread was called
int lastCallRender = 0; //lastCallRender
int lastCallMisc = 0;

//time passed since last call 
int deltaTLogic = 0;
int deltaTRender = 0;

//how often we already called the threads
int countLogicCalls = 0;
int countRenderCalls = 0;

//used to know  how many calls since last fps calculation
int countLogicCallsOld = 0;
int countRenderCallsOld = 0;


/*
Warning! Vsync of your graphics card could reduce your logic fps or your render  fps to your monitor refresh rate!
 Warning! you may even want to have Vsync, i cant help you here.
 */

//framerate of Logic/Render threads
//-1 to run as fast as  possible. be prepared to melt your pc!
int framerateLogic = 500;
int framerateRender = 200;

int framerateMisc = 1; //how often the framerate display will be updated



void setup() {

  //init window
  size(1280,700); //creates a new window
  graphics = createGraphics(1280, 700);//creates the draw area
  frameRate(framerateRender); //tells the draw function to run

  /*
  why we use createGraphics:

   Unlike the main drawing surface which is completely opaque, surfaces created with createGraphics() can have transparency. 
   This makes it possible to draw into a graphics and maintain the alpha channel. By using save() to write a PNG or TGA file,
   the transparency of the graphics object will be honored. 

   from: https://www.processing.org/reference/createGraphics_.html

   */
  f = createFont("Raleway-ExtraLight.vlw", 32, true);
  textAlign(CENTER);
  ellipseMode(CENTER);

  kinect = new Kinect(this);
  //kinect.start();
  //kinect.enableRGB(rgb);
  //kinect.enableIR(ir);
  //kinect.tilt(deg);
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

  //thread("refreshTweets");
  //thread("userTimeRange");
  //thread("mousePressed");
  //thread("dump");
  getNewTweets();
  background(0);

  //start Threads
  //Start a Thread for Logic!
  //Use this one for your logic calculations!
  logicThread.start();

  //start the graphics Thread!
  //actually we render in the main Thread. opengl and lots of other render stuff want to run in the main Thread.
  //Therefore we dont start a new thread and will put the drawing into processings draw() method.
  println(Thread.currentThread().getName() +" : the MainThread is running and used to Render");

  //start the misc Thread. it counts the fps etc.
  //use this for wierd stuff like counting fps and all weird things you can think of that doesnt belong into logic nor rendering
  miscThread.start();
}

//draw function. This is our Render Thread
void draw() {

  countRenderCalls++;

  graphics.beginDraw();


  /*
      all drawing calls have to be called from the graphics object.
   so graphics.line(0,0,100,100) instead of line(0,0,100,100)
   */
  //-------------

  graphics.background(0);
  


  //dump();
  //getTweet();
  //getDetails();
  //getImage();
  //getScreenName();


  //-------------
  graphics.endDraw();
  image(graphics, 0, 0);
  //no sleep calculation here because processing  is doing  it for us already
}


//Pretty ugly way  to create a new Thread. There is a nicer way 
//in java 8 but because of backward compatibility we write code  that also  runs in java7
// Passing a Runnable when creating a new thread
Thread logicThread = new Thread(new Runnable() {
  public void run() {
    System.out.println(Thread.currentThread().getName() + " : the logicThread is running");

    //main Logic loop
    while (true) {


      countLogicCalls++;
      //------------
      tracker.track();


      //------------
      //framelimiter
      int timeToWait = 1000/framerateLogic - (millis()-lastCallLogic); // set framerateLogic to -1 to not limit;
      if (timeToWait > 1) {
        try {
          //sleep long enough so we aren't faster than the logicFPS
          Thread.currentThread().sleep( timeToWait );
        }
        catch ( InterruptedException e )
        {
          e.printStackTrace();
          Thread.currentThread().interrupt();
        }
      }
      /*
      example why we wait excactly: 1000/framerate - (millis-lastcall)

       framerate = 100 //framerate we want
       1000/framerate = 10 //time for one loop
       millis = 1952 //current time
       last call logic = 1949 //time when last logic loop finished

       how  long should the programm wait??

       millis-lastcall = 3 -> the whole loop took 3ms

       1000/framerate - (millis-lastcall) = 7ms -> we will have to wait 7ms to keep a framerate of 100

       */

      //remember when the last logic loop finished
      lastCallLogic = millis();


      //End of main logic loop
    }
  }
}
);


// Passing a Runnable when creating a new thread
Thread miscThread = new Thread(new Runnable() {
  public void run() {
    System.out.println(Thread.currentThread().getName() + " : the miscThread is running");
    /*
you can access all variables that are defined in main!
     how wunderful and convienent to create lots of global variables! ... im sorry :D
     */



    //main misc loop
    while (true) {

      //-------------      


      refreshTweets();


      //fps calculation goes here
      surface.setTitle("logicFPS: " + (countLogicCalls-countLogicCallsOld) +" RenderFps: " + (countRenderCalls-countRenderCallsOld)); //Set the frame title to the frame rate
      countLogicCallsOld = countLogicCalls;
      countRenderCallsOld =countRenderCalls; 

      //----------




      //-------------



      //framelimiter
      int timeToWait = 1000/framerateMisc - (millis()-lastCallMisc); // set to -1 to not limit
      if (timeToWait > 1) {
        try {
          //sleep long enough so we aren't faster than the logicFPS
          Thread.currentThread().sleep( timeToWait );
        }
        catch ( InterruptedException e )
        {
          e.printStackTrace();
          Thread.currentThread().interrupt();
        }
      }
      /*
      example why we wait excactly: 1000/framerate - (millis-lastcall)

       framerate = 100

       1000/framerate = 10

       millis = 1952
       lastcall = 1949

       how  long should the programm wait??

       millis-lastcall = 3 -> the whole excetion took 3ms

       1000/framerate - (millis-lastcall) = 7ms -> we will have to wait 7ms to keep a framerate of 100

       */


      lastCallMisc = millis();

      //End of main misc loop
      // yes here have to be 4 paranthesis
    }
  }
}
);

void userLocationRange() {
  userLocationCircle1.buildUserRange();
}

void userTimeRangeBackground() {
  graphics.background(0);
  graphics.noFill();
  graphics.stroke(153);
  graphics.ellipse(628, 338, (height * sizeModLarge), (height * sizeModLarge));
  graphics.ellipse(628, 338, (height * sizeModMed), (height * sizeModMed));
  graphics.ellipse(628, 338, (height * sizeModSmall), (height * sizeModSmall));
  graphics.ellipse(628, 338, (height * sizeModXS), (height * sizeModXS));
}

void userFollowerRangeBackground() {
  graphics.noFill();
  graphics.stroke(153);
  graphics.ellipse(628, 338, (height * sizeModLarge), (height * sizeModLarge));
  graphics.ellipse(628, 338, (height * sizeModMed), (height * sizeModMed));
  graphics.ellipse(628, 338, (height * sizeModSmall), (height * sizeModSmall));
  graphics.ellipse(628, 338, (height * sizeModXS), (height * sizeModXS));
}

void userTimeRange() {
  userTimeRange1.buildRange();
  userTimeRange2.buildRange();
  userTimeRange3.buildRange();
  userTimeRange4.buildRange();
  graphics.translate(628, 338);
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
  graphics.translate(628, 338);
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
    delay(7000);
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
  graphics.text(userTweet, (width/2), 300, 700, 250);
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

  graphics.text("@" + userName, (width/2), 350);
  graphics.text(userLocation, (width/2), 400, 200);
  graphics.text(userFollowers + " followers", (width/2), 450);
  graphics.text(reportDate, width/2, 500);
  graphics.image(userImage, width/2, 100);
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