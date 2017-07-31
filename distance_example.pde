import processing.io.*;

// image variables
int offset = 0;
int total = 10;
PImage[] images = new PImage[total];
float imgScale = 2;


// GPIO variables
int TRIG = 20;
int ECHO = 26;

int out = GPIO.OUTPUT;
int in = GPIO.INPUT;

float sensedDistance;
float dist, prevDist;

void Log() {
  println("");
  println("Log Sensed Distance");
  println(prevDist, dist);
  println("*********************");
}

void setup() {
  // setup GPIO pins
  GPIO.pinMode(TRIG, out);
  GPIO.pinMode(ECHO, in);

  frameRate(2);

  sensedDistance = 30;
  prevDist = 1000;

  for (int i = 0; i < 10; i++) {
    images[i] = loadImage("./images/tree" + (i+1) + ".png");
  }

}

void draw() {
  background(#FFFFFF);
  PImage image = images[offset];
  float imgWidth = image.width * imgScale;
  float imgHeight = image.height * imgScale;

  image(image, width/2 - imgWidth/2, height-imgHeight, imgWidth, imgHeight);


  dist = getDistance();

  if (dist > sensedDistance && prevDist < sensedDistance) {
    onFire();
  }

  //Log();
  prevDist = dist;
}


void onFire() {
  println("Fire");
  offset = (offset + 1) % total;
}


float getDistance() {
  long pulse_start, pulse_end;
  float dist;

  GPIO.digitalWrite(TRIG, GPIO.LOW);
  delay(3);

  GPIO.digitalWrite(TRIG, true);
  delay(1);
  GPIO.digitalWrite(TRIG, false);

  pulse_start = System.nanoTime();
  while (GPIO.digitalRead(ECHO) == 0) {
    pulse_start = System.nanoTime();
  }

  while (GPIO.digitalRead(ECHO) == 1) {
    pulse_end = System.nanoTime();
  }
  pulse_end = System.nanoTime();

  dist = ((pulse_end - pulse_start) / 1000000.0 * 17);

  return dist;
}
