PImage imgClose;

void setup() {
  size(640, 480);
  imgClose = requestImage("1.png");
}

void draw() {
  image(imgClose,0,0);
}
