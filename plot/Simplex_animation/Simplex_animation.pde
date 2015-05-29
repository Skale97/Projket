String lines[] = loadStrings("C:\\Users\\Marko\\Desktop\\sketch_150529a\\foo.txt");
float[] x = new float[lines.length/2];
float[] y = new float[lines.length/2];
int i = 0;
int c = 2;
int xk = 300;
int yk = 250;
void setup() {
  printArray(lines);
  size(640, 480);
  for (int i = 0; i < lines.length/2; i++) {
    x[i] = float(lines[i]);
    y[i] = float(lines[i+lines.length/2]);
    println(x[i]+", "+y[i]);
  }
  ellipseMode(CENTER);
  frameRate(2);
}

void draw() {
  background(255);
  line(x[i]*c+xk, y[i]*c+yk, x[i+1]*c+xk, y[i+1]*c+yk);
  line(x[i+1]*c+xk, y[i+1]*c+yk, x[i+2]*c+xk, y[i+2]*c+yk);
  line(x[i]*c+xk, y[i]*c+yk, x[i+2]*c+xk, y[i+2]*c+yk);
  ellipse(xk, yk, 5, 5);
  i+=3;
  if (i>x.length-1) i=0;
}

