class UserLocationCircle {
  String getlink;
  String locList;
  String locString;
  String[] nameArray;
  float lg_diam;
  float cx;
  float cy;
  int threshold;
  int staticIconSize;
  int count;
  float r;
  float rr;
  float angle;
  float arclength = 0;
  float radiMod = 0;
  processing.data.JSONArray values;
  processing.data.JSONArray locArray;

  // The Constructor is defined with arguments.
  UserLocationCircle(String link, String locLink, float diam, float locX, float locY, int t, int s, float r_) {
    getlink = link;
    locList = locLink;
    lg_diam = diam;
    cx = locX;
    cy = locY;
    threshold = t;
    staticIconSize = s;
    r = r_;
  }

  void buildUserRange() {


    background(0);

    circleSizeMod = 0.2;
    iconRadiMod = 0.01;

    GetRequest get = new GetRequest(getlink);
    GetRequest locationRequest = new GetRequest(locList);
    get.send();
    locationRequest.send();
    get.addHeader("Accept", "application/json");
    locationRequest.addHeader("Accept", "application/json");

    float lg_rad = lg_diam / 2;
    float lg_circ = PI * lg_diam;

    processing.data.JSONObject values = processing.data.JSONObject.parse(get.getContent());
    processing.data.JSONArray locArray = processing.data.JSONArray.parse(locationRequest.getContent());
    rr = 0.1;
    r = (height * 0.15);

    for (int i = 0; i < locArray.size(); i++) {
      processing.data.JSONObject locObject = locArray.getJSONObject(i);
      nameArray = new String[locArray.size()];
      String currentLoc = locObject.getString("intimacy_location");
      nameArray[i] = currentLoc;

      println(nameArray[i]);

      noFill();
      stroke(153);
      ellipse(628, 338, (height * circleSizeMod), (height * circleSizeMod));
      circleSizeMod += 0.2;
      iconRadiMod += 0.393;
      for (int tt = 0; tt < nameArray.length; tt++) {
        for (int t = 0; t < nameArray[i].length(); t++) {

          char currentChar = nameArray[i].charAt(t);
          float w = textWidth(currentChar);
          arclength += w/2 + 2;
          float theta = PI + arclength / r; 
          pushMatrix();
          translate(628, 338);
          translate(r*cos(theta), r*sin(theta));
          rotate(theta+PI/2); // rotation is offset by 90 degrees
          fill(255);
          textSize(18);
          text(currentChar, 0, 0);
          popMatrix();

          arclength += w/2 + 2;
          println(currentChar);
          translate(0, 0);
        }
        r = (height * (0.15 + rr));
      }
      String encodedLocString = URLEncoder.encode(nameArray[i]);
      GetRequest locGet = new GetRequest("https://i7226684.budmd.uk/intimacy/dumper/locentry.php?location=" + encodedLocString);
      locGet.send();
      locGet.addHeader("Accept", "application/json");
      processing.data.JSONArray locEntry = processing.data.JSONArray.parse(locGet.getContent());
      int count = locEntry.size();

      //for (int ii = 0; ii < locEntry.size(); ii++) {


      //  //println(locEntry);

      //  processing.data.JSONObject imgObject = locEntry.getJSONObject(ii);
      //  String imgURL = imgObject.getString("intimacy_img");

      //  //println(imgURL);
      //  userLocation = loadImage(imgURL);



      //  angle = ii * TWO_PI / count;
      //  float x = cx + cos(angle) * (lg_diam * iconRadiMod);
      //  float y = cy + sin(angle) * (lg_diam * iconRadiMod);

      //  float sm_diam = (lg_circ / count);
      //  int masksize = (int)sm_diam;

      //  int imgX;
      //  int imgY;


      //  //static sizes------------
      //  if (count < threshold == true) {
      //    graphicalMask=createGraphics(staticIconSize, staticIconSize);
      //  } else {
      //    graphicalMask=createGraphics(masksize, masksize);
      //  }

      //  graphicalMask.beginDraw();

      //  graphicalMask.background(0);

      //  if (count < threshold == true) {
      //    imgX = staticIconSize/2;
      //    imgY = staticIconSize/2;
      //  } else {
      //    imgX = masksize/2;
      //    imgY = masksize/2;
      //  }

      //  graphicalMask.fill(255);
      //  graphicalMask.noStroke();

      //  if (count < threshold == true) {
      //    graphicalMask.ellipse(imgX, imgY, staticIconSize, staticIconSize);
      //  } else {
      //    graphicalMask.ellipse(imgX, imgY, masksize, masksize);
      //  }

      //  graphicalMask.endDraw();

      //  if (count < threshold == true) {

      //    userLocation.resize(staticIconSize, staticIconSize);
      //  } else {
      //    userLocation.resize(masksize, masksize);
      //  }

      //  userLocation.mask(graphicalMask);

      //  if (count < threshold == true) {

      //    image(userLocation, x, y, staticIconSize, staticIconSize);
      //  } else {
      //    image(userLocation, x, y, masksize, masksize);
      //  }
      //}
    }
  }
}