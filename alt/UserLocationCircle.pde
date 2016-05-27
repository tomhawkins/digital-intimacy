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
  float w;
  float theta;
  float arcMod = 0;
  char currentChar;
  int t = 0;
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

    circleSizeMod = 0.3;
    iconRadiMod -= 1.5;
    radiMod = 0.05;

    GetRequest get = new GetRequest(getlink);
    GetRequest locationRequest = new GetRequest(locList);
    get.send();
    locationRequest.send();
    get.addHeader("Accept", "application/json");
    locationRequest.addHeader("Accept", "application/json");

    //float lg_circ = (2 * PI) * lg_rad;

    processing.data.JSONObject values = processing.data.JSONObject.parse(get.getContent());
    processing.data.JSONArray locArray = processing.data.JSONArray.parse(locationRequest.getContent());

    for (int i = 0; i < locArray.size(); i++) {
      processing.data.JSONObject locObject = locArray.getJSONObject(i);
      nameArray = new String[locArray.size()];
      String currentLoc = locObject.getString("intimacy_location");
      nameArray[i] = currentLoc;

      noFill();
      stroke(153);
      ellipse(width/2, height/2, (height * circleSizeMod), (height * circleSizeMod));
      circleSizeMod += 0.3;
      iconRadiMod += 1.195;
      radiMod += 0.1575;
      arclength -= 150;
      arcMod += 0.0;

      float lg_rad = ((height * circleSizeMod) / 2);

      String encodedLocString = URLEncoder.encode(nameArray[i]);
      GetRequest locGet = new GetRequest("https://i7226684.budmd.uk/intimacy/dumper/locentry.php?location=" + encodedLocString);
      locGet.send();
      locGet.addHeader("Accept", "application/json");
      processing.data.JSONArray locEntry = processing.data.JSONArray.parse(locGet.getContent());
      int count = locEntry.size();
      translate(0, 0);

      for (int ii = 0; ii < locEntry.size(); ii++) {

        imageMode(CENTER);
        //println(locEntry);

        processing.data.JSONObject imgObject = locEntry.getJSONObject(ii);
        String imgURL = imgObject.getString("intimacy_img");

        //println(imgURL);
        userLocation = loadImage(imgURL);

        angle = ii * TWO_PI / locEntry.size();
        //float x = cx + cos(angle) * (lg_rad * iconRadiMod);
        //float y = cy + sin(angle) * (lg_rad * iconRadiMod);

        float x = cx + cos(angle) * ((height * circleSizeMod / 2) - 105);
        float y = cy + sin(angle) * ((height * circleSizeMod / 2) - 105);



        float sm_diam = ((PI) * ((height * circleSizeMod) / 2) / locEntry.size());
        //println(locEntry.size());
        int masksize = (int)(sm_diam);

        int imgX;
        int imgY;

        if (i == 0) {
          threshold = 12;
        } else if (i == 1) {
          masksize = masksize *= 1.35;
          threshold = 22;
        } else if (i == 2) {
          masksize = masksize *= 1.5;
          threshold = 32;
        } else if (i == 3) {
          masksize = masksize *= 1.65;
          threshold = 42;
        } else if (i == 4) {
          masksize = masksize *= 1.75;
          threshold = 52;
        } else if (i == 5) {
          masksize = masksize *= 2.15;
          threshold = 62;
        } else if (i == 6) {
          masksize = masksize *= 2.35;
          threshold = 72;
        } else if (i == 7) {
          masksize = masksize *= 2.55;
          threshold = 82;
        } else if (i == 8) {
          masksize = masksize *= 2.75;
          threshold = 92;
        } else if (i == 9) {
          masksize = masksize *= 2.95;
          threshold = 102;
        } else if (i == 10) {
          masksize = masksize *= 3.15;
          threshold = 112;
        } else if (i == 11) {
          masksize = masksize *= 3.35;
          threshold = 122;
        } else if (i == 12) {
          masksize = masksize *= 3.55;
          threshold = 132;
        } else if (i == 13) {
          masksize = masksize *= 3.75;
          threshold = 142;
        } else if (i == 14) {
          masksize = masksize *= 3.95;
          threshold = 152;
        } else if (i == 15) {
          masksize = masksize *= 4.05;
          threshold = 162;
        } else if (i == 16) {
          masksize = masksize *= 4.15;
          threshold = 172;
        } else if (i == 17) {
          masksize = masksize *= 4.35;
          threshold = 182;
        } else if (i == 18) {
          masksize = masksize *= 4.55;
          threshold = 192;
        } else if (i == 19) {
          masksize = masksize *= 4.75;
          threshold = 202;
        } else if (i == 20) {
          masksize = masksize *= 4.95;
          threshold = 212;
        } else if (i == 21) {
          masksize = masksize *= 5.15;
          threshold = 222;
        } else if (i == 22) {
          masksize = masksize *= 5.35;
          threshold = 232;
        } else if (i == 23) {
          masksize = masksize *= 5.55;
          threshold = 242;
        } else if (i == 24) {
          masksize = masksize *= 5.75;
          threshold = 252;
        } else if (i == 25) {
          masksize = masksize *= .95;
          threshold = 262;
        } else {
          break;
        }


        //static sizes------------
        if (count < threshold == true) {
          graphicalMask=createGraphics(staticIconSize, staticIconSize);
        } else {
          graphicalMask=createGraphics(masksize, masksize);
        }

        graphicalMask.beginDraw();

        graphicalMask.background(0);

        if (count < threshold == true) {
          imgX = staticIconSize/2;
          imgY = staticIconSize/2;
        } else {
          imgX = masksize/2;
          imgY = masksize/2;
        }

        graphicalMask.fill(255);
        graphicalMask.noStroke();

        if (count < threshold == true) {
          graphicalMask.ellipse(imgX, imgY, staticIconSize, staticIconSize);
        } else {
          graphicalMask.ellipse(imgX, imgY, masksize, masksize);
        }

        graphicalMask.endDraw();

        if (count < threshold == true) {

          userLocation.resize(staticIconSize, staticIconSize);
        } else {
          userLocation.resize(masksize, masksize);
        }

        userLocation.mask(graphicalMask);

        if (count < threshold == true) {

          image(userLocation, x, y, staticIconSize, staticIconSize);
        } else {
          image(userLocation, x, y, masksize, masksize);
        }
      }

      for (int t = 0; t < nameArray[i].length(); t++) {

        currentChar = nameArray[i].charAt(t);
        w = textWidth(currentChar);
        arclength += w/2 + 2;
        theta = PI + arclength / lg_rad; 
        pushMatrix();
        translate(width/2, height/2);
        translate((height*radiMod)*cos(theta), (height*radiMod)*sin(theta));
        rotate(theta+PI/2); // rotation is offset by 90 degrees
        fill(255);
        textSize(18);
        text(currentChar, 0, 0);
        popMatrix();

        arclength += w/2 + 2;
        //println(currentChar);
      }
    }
  }
}