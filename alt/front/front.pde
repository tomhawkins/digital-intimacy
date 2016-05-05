float posX, posY;
float radiusX, radiusY;
float theta;
float i;

void setup() {
  size( 1280, 800 );

  posX = posY = 0;

  radiusX = 200;
  radiusY = 200;

  theta = 0;
}

void draw() { 
  background( 0 );
  translate( width / 2, height / 2 );
  fill( 255 );

  for (int theta = 0; theta < 100; theta = theta+=50) {
    ellipse( radiusX * cos(theta), radiusY * sin(theta), 30, 30 );
  }
}