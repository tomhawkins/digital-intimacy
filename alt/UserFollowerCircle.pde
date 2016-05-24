class UserFollowerCircle {
  String getlink;
  float lg_diam;
  float cx;
  float cy;
  int threshold;
  int staticIconSize;
  int count;
  float angle;
  processing.data.JSONArray values;

  // The Constructor is defined with arguments.
  UserFollowerCircle(String link, float diam, float locX, float locY, int t, int s) {
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
      processing.data.JSONObject followersObject = values.getJSONObject(i);
      String imgURL = followersObject.getString("intimacy_img");
      userFollowers = loadImage(imgURL);

      angle = i * TWO_PI / count;
      float x = cx + cos(angle) * lg_rad;
      float y = cy + sin(angle) * lg_rad;

      float sm_diam = (lg_circ / count);
      int masksize = (int)sm_diam;

      int imgX;
      int imgY;


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

        userFollowers.resize(staticIconSize, staticIconSize);
      } else {
        userFollowers.resize(masksize, masksize);
      }

      userFollowers.mask(graphicalMask);



      if (count < threshold == true) {

        image(userFollowers, x, y, staticIconSize, staticIconSize);
      } else {
        image(userFollowers, x, y, masksize, masksize);
      }
    }
  }
}