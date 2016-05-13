class UserLocationCircle {
  String getlink;
  String locList;
  String locString;
  float lg_diam;
  float cx;
  float cy;
  int threshold;
  int staticIconSize;
  int count;
  float angle;
  processing.data.JSONArray values;
  processing.data.JSONArray locArray;

  // The Constructor is defined with arguments.
  UserLocationCircle(String link, String locLink, float diam, float locX, float locY, int t, int s) {
    getlink = link;
    locList = locLink;
    lg_diam = diam;
    cx = locX;
    cy = locY;
    threshold = t;
    staticIconSize = s;
  }

  //void buildUserLocation() {

  //  circleSizeMod = 0;
  //  //int count = locArray.size();

  //  for (int l = 0; l <= 3; l++) {
  //    noFill();
  //    stroke(153);
  //    ellipse(628, 338, (height * circleSizeMod), (height * circleSizeMod));
  //    circleSizeMod += 0.2;
  //    println(locArray.size());
  //    processing.data.JSONArray currentLoc = values.getJSONArray(l);

  //    //for (int ii = 0; ii < currentLoc.size(); ii++) {

  //    //String user = currentLoc.getString(ii);
  //    //println(user);
  //    //}
  //  }
  //}

  //for (int i = 0; i < count; i++) {
  //  //processing.data.JSONObject locationObject = locArray.getJSONObject(i);
  //  //String imgURL = locationObject.getString("intimacy_img");
  //  //userLocation = loadImage(imgURL);

  //  angle = i * TWO_PI / count;
  //  float x = cx + cos(angle) * lg_rad;
  //  float y = cy + sin(angle) * lg_rad;

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

  //    //userLocation.resize(staticIconSize, staticIconSize);
  //  } else {
  //    //userLocation.resize(masksize, masksize);
  //  }

  //  //userLocation.mask(graphicalMask);

  //  //fill(0, 10);
  //  //rect(0, 0, width, height);
  //  //fill(0);

  //  if (count < threshold == true) {

  //    //image(userLocation, x, y, staticIconSize, staticIconSize);
  //  } else {
  //    //image(userLocation, x, y, masksize, masksize);
  //  }
  //}
  //}

  void buildUserRange() {

    circleSizeMod = 0.2;

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

    int count = values.size();

    for (int i = 0; i < locArray.size(); i++) {
      processing.data.JSONObject locObject = locArray.getJSONObject(i);
      //String locString = locObject.getString("intimacy_location");
      //println("Location: " + locString);
      //processing.data.JSONArray currentLoc = values.getJSONArray(i);
      noFill();
      stroke(153);
      ellipse(628, 338, (height * circleSizeMod), (height * circleSizeMod));
      circleSizeMod += 0.2;

      //for (int ii = 0; ii < currentLoc.size(); ii++) {

      //  String user = currentLoc.getString(ii);
      //  println(user);
    }
  }
}

//