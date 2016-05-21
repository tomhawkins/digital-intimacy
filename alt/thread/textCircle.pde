class TextCircle {

  // We must keep track of our position along the curve
  float arclength = 0;

  String message;
  float r;
  float w;
  char currentChar;

  TextCircle(String text, float radius) {
    message = text;
    r = radius;
  }

  void buildText() {


    // We must keep track of our position along the curve
    float arclength = 0;


    for (int i = 0; i < message.length(); i++)
    {
      // Instead of a constant width, we check the width of each character.
      currentChar = message.charAt(i);
      w = textWidth(currentChar);

      // Each box is centered so we move half the width
      arclength += w/2;

      // Angle in radians is the arclength divided by the radius

      // Starting on the left side of the circle by adding PI
      float theta = PI + arclength / r;    

      pushMatrix();

      // Polar to cartesian coordinate conversion
      translate(r*cos(theta), r*sin(theta));

      // Rotate the box
      rotate(theta+PI/2); // rotation is offset by 90 degrees

      // Display the character
      textSwitch = true;
    }
  }

  void render() {

    graphics.fill(255);
    graphics.textSize(18);
    graphics.text(currentChar, 0, 0);
    popMatrix();

    // Move halfway again
    arclength += w/2 + 2;
  }
}