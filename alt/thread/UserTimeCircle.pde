class UserTimeCircle {
  String getlink;
  float lg_diam;
  float cx;
  float cy;
  int threshold;
  int staticIconSize;
  int count;
  float angle;
  float x;
  float y;
  int masksize;
  processing.data.JSONArray values;

  // The Constructor is defined with arguments.
  UserTimeCircle(String link, float diam, float locX, float locY, int t, int s) {
    getlink = link;
    lg_diam = diam;
    cx = locX;
    cy = locY;
    threshold = t;
    staticIconSize = s;
  }

  void buildRange()
  {

    GetRequest get = new GetRequest(getlink);
    get.send();
    get.addHeader("Accept", "application/json");

    float lg_rad = lg_diam / 2;
    float lg_circ = PI * lg_diam;

    processing.data.JSONArray values = processing.data.JSONArray.parse(get.getContent());
    int count = values.size();

    for (int i = 0; i < count; i++) {
      processing.data.JSONObject timesObject = values.getJSONObject(i);
      String imgURL = timesObject.getString("intimacy_img");
      userTime = loadImage(imgURL);

      angle = i * TWO_PI / count;
      x = cx + cos(angle) * lg_rad;
      y = cy + sin(angle) * lg_rad;

      float sm_diam = (lg_circ / count);
      masksize = (int)sm_diam;

      if (count < threshold == true) {

        userTime.resize(staticIconSize, staticIconSize);
      } else {
        userTime.resize(masksize, masksize);
      }

      int imgX;
      int imgY;


      //static sizes------------
      //if (count < threshold == true) {
      //  graphicalMask=createGraphics(staticIconSize, staticIconSize);
      //} else {
      //  graphicalMask=createGraphics(masksize, masksize);
      //}

      //graphicalMask.beginDraw();

      //graphicalMask.background(0);

      //if (count < threshold == true) {
      //  imgX = staticIconSize/2;
      //  imgY = staticIconSize/2;
      //} else {
      //  imgX = masksize/2;
      //  imgY = masksize/2;
      //}

      //graphicalMask.fill(255);
      //graphicalMask.noStroke();

      //if (count < threshold == true) {
      //  graphicalMask.ellipse(imgX, imgY, staticIconSize, staticIconSize);
      //} else {
      //  graphicalMask.ellipse(imgX, imgY, masksize, masksize);
      //}

      //graphicalMask.endDraw();




      //////fill(0, 10);
      //////rect(0, 0, width, height);
      //////fill(0);

      //userTime.mask(graphicalMask);

      if (count < threshold == true) {
        //println("userTimeLowThreshold is True");
        graphics.image(userTime, x, y, staticIconSize, staticIconSize);
      } else {
        //println("userTimeHighThreshold is True");
        graphics.image(userTime, x, y, masksize, masksize);
      }
    }
  }
}