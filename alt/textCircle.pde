class TextCircle {

  // We must keep track of our position along the curve
  float arclength = 0;

  String message;
  float r;

  TextCircle(String text, float radius) {
    message = text;
    r = radius;
  }

  void buildText() {


    // We must keep track of our position along the curve
    float arclength = 0;
    //ellipseMode(CENTER);
    //textMode(CORNER);

    for (int i = 0; i < message.length(); i++)
    {

      //translate(0, 0);
      // Instead of a constant width, we check the width of each character.
      char currentChar = message.charAt(i);
      float w = textWidth(currentChar);

      // Each box is centered so we move half the width
      arclength += w/2;

      // Angle in radians is the arclength divided by the radius

      // Starting on the left side of the circle by adding PI
      float theta = PI + arclength / r;    

      pushMatrix();

      // Polar to cartesian coordinate conversion
      translate((r)*cos(theta), (r)*sin(theta));

      translate(width/2,height/2);

      // Rotate the box
      rotate(theta+PI/2); // rotation is offset by 90 degrees

      // Display the character
      fill(255);
      textSize(18);
      text(currentChar, 0, 0);
      popMatrix();

      // Move halfway again
      arclength += w/2 + 2;
    }
  }
}