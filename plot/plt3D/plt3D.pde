int n = 99;
int d = 2;
int cr = 1000;
float max;
String sdata[][][] = new String[n][n][n];
float data[][][] = new float[n][n][n];

void setup() {
  size(700, 700, P3D);
  background(255);
  colorMode(HSB, cr);
  frameRate(30);

  String dim1[] = loadStrings("E:\\GitHub\\Projke\\plot\\plt3D\\asdf.txt");
  for (int i = 0; i<n; i++) {
    String dim2[] = split(dim1[i], ',');
    for (int j = 0; j<n; j++) {
      String dim3[] = split(dim2[j], ' '); 
      for (int k = 0; k<n; k++) {
        data[i][j][k] = float(dim3[k]);
        if(data[i][j][k]>max) max = data[i][j][k];
      }
    }
  }
  max = 50;
}

void draw() {
  fill(cr);
  noStroke();
  background(cr);
  
  for (int i = 0; i<cr*2/3; i++) {
    noStroke();
    fill(cr*2/3-i, cr, cr);
    rect(i, 0, 1, 10);
  }
  
  text("0 cm", 10, 30);
  text(max+" cm", cr*2/3-70, 30);
  
  pushMatrix();
  translate(350, 350, 350);
  rotateY((mouseX-350.0)/350.0*PI);
  rotateX(-(mouseY-350.0)/350.0*PI);
  for (int k = 0; k<n; k++) {
    pushMatrix();
    translate(-n/2*d, -n/2*d, k*d-n/2*d);
    for (int i = 0; i<n; i++) {
      for (int j = 0; j<n; j++) {
        stroke(cr*2/3-data[i][j][k]/max*2/3*cr, cr, cr, cr/10+data[i][j][k]*50);
        strokeWeight(d*3);
        point(i*d, j*d);
      }
    }
    popMatrix();
  }
  popMatrix();
}

