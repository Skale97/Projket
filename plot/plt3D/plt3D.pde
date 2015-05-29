Table data;
void setup() {
  size(700, 700, P3D);
  background(255);
  colorMode(HSB, 1000);
  data = loadTable("k500Hz.csv") ;
  println(data.getColumnCount());
  pushMatrix();
  rotateX(-PI/10);
  rotateY(-PI/8);
  for (int k = 0; k<40; k++) {
    pushMatrix();
    translate(300, 200, k*5);
    for (int i = 0; i<40; i++) {
      for (int j = 0; j<40; j++) {
        stroke(data.getFloat(i, j)*4, 1000, 1000, 100);
        strokeWeight(5);
        point(i*5, j*5);
      }
    }
    popMatrix();
  }
  popMatrix();
}

