int n = 50;  // depending on your PC, you can try to make this number smaller and make program run faster in 3D mode
int d = 3;
int cr = 1000;
float max;
String sdata[][][] = new String[n][n][n];
float data[][][] = new float[n][n][n];
int div = 10;
Boolean topView = false;
int depth = 0;

void setup() {
  size(700, 700, P3D);
  background(255);
  colorMode(HSB, cr);
  frameRate(30);
//Učitavanje podataka iz file-a
  String dim1[] = loadStrings("E:\\Git Hub\\Projket\\plot\\plt3D\\asdf.txt");
  for (int i = 0; i<n; i++) {
    String dim2[] = split(dim1[i*2], ',');
    for (int j = 0; j<n; j++) {
      String dim3[] = split(dim2[j*2], ' '); 
      for (int k = 0; k<n; k++) {
        data[i][j][k] = float(dim3[k*2]);
        if ((i == 0 && j == n/2 && (k == 0 || k == n-1)) || (i == n-1 && k == n/2 && (j == 0 || j == n-1)))
          data[i][j][k] = 0.123;  //Prikazivanje pozicije mikrofona, crne tačke
        if (data[i][j][k]>max) max = data[i][j][k]; //Traženje maksimuma, potrebno za skaliranje boje
      }
    }
  }
  max = 50;
}

void draw() {
  fill(cr);
  noStroke();
  background(cr);

  for (int i = 0; i<cr*2/12; i++) { //Color scale line
    noStroke();
    fill(cr*2/3-i*4, cr, cr);
    rect(i*4, 0, 4, 10);
  }

  text("0 cm", 10, 30);
  text(max+" cm", cr*2/3-70, 30);

  if (!topView) {//3D view, move mouse to rotate, if your PC is slow change n, or use topView mode
    pushMatrix();
    translate(350, 350, 350);
    rotateY((mouseX-350.0)/350.0*PI);
    rotateX(-(mouseY-350.0)/350.0*PI);
    for (int k = 0; k<n; k++) {
      pushMatrix();
      translate(-n/2*d, -n/2*d, k*d-n/2*d);
      for (int i = 0; i<n; i++) {
        for (int j = 0; j<n; j++) {
          stroke(cr*2/3-data[i][j][k]/max*2/3*cr, cr, cr, cr/div);
          if (data[i][j][k] == 0.123)
            stroke(0, 0, 0);
          strokeWeight(d*3);
          point(i*d, j*d);
        }
      }
      popMatrix();
    }
    popMatrix();
  } else { //top view mode
    for (int i = 0; i<n; i++) {
      for (int j = 0; j<n; j++) {
        fill(cr*2/3-data[i][j][depth]/max*2/3*cr, cr, cr);
        if (data[i][j][depth] == 0.123)
          fill(0, 0, 0);
        rect(i*d+width/2-n/2*d, j*d+height/2-n/2*d, d, d);
      }
    }
  }
}

void keyPressed() {
  if (key == 'q') {
    d++;      //Zoom
  } else if (key == 'a') {
    d--;      //Zoom
  } else if (key == 'w') {
    max+=5;    //Maximum of color scale
  } else if (key == 's') {
    max-=5;    //Maximum of color scale
  } else if (key == 'e') {
    div++;    //Color scale
    println(div);
  } else if (key == 'd') {
    div--;    //Color scale
    println(div);
  }
  if (key == 'k') {
    topView = !topView; // Toggle view
  }
}

void mouseWheel(MouseEvent e) {  //Change depth in top view
  depth -= e.getCount();
  if (depth<0) depth = 0;
  else if (depth>=n) depth = n-1;
  println(depth);
}