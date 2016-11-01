int sine[][];
int ns = 500;
int tmax, ltmax, max = 0, pos, orig, mes;
int div = 50000;
Boolean stop = false;

void setup() {
  size(1000, 600);
  frameRate(25);

  sine = new int[2][ns];
  for (int i = 0; i<ns; i++) {
    sine[0][i] = 0;
  }
  for (int i = 0; i<ns; i++) {/*
    if (i<ns*0.2) {
   float ang = sin(i*PI/(ns*0.2));
   sine[0][i] = int(random(-120, 120)*sin(i*(PI/(ns*0.2))));
   }*/
    sine[0][i]+=int(random(-120, 120))+120;
  }
  orig = 0;
}

void draw() {
  if (!stop) {
    if (orig<ns) orig++;
    measure();
  }
}

void keyPressed() {
  if (keyCode == UP) orig++;
  else if (keyCode == DOWN) orig--;
  else if (key == 's') stop= !stop;
  println(orig);
  measure();
}

void measure() {
  background(255);
  sine[1][0] = 0;
  for (int i = 1; i<ns; i++) {
    sine[1][i] = 0;
    line(i*2, sine[0][i-1]+100, (i+1)*2, sine[0][i]+100);
  }

  for (int i = 0; i<ns; i++) {
    if (i+orig>=0 && i+orig<ns) 
      sine[1][i+orig] = int(sine[0][i]);
    if (i<orig)
      sine[1][i] = int(random(-120, 120))+120;
    if (i>0)
      line(i*2, sine[1][i-1]+300, (i+1)*2, sine[1][i]+300);
    sine[1][i]+=int(random(-5, 5));
  }

  for (int i = 0; i<ns; i++) {
    tmax = 0;
    for (int j = 0; i+j<ns; j++) {
      
        tmax += sine[0][j]*sine[1][i+j];
    }
    line(i*2, -ltmax/div+500, (i+1)*2, -tmax/div+500);
    if (tmax>max) 
    {
      max = tmax;
      pos = i;
    }
    ltmax = tmax;
  }
  mes = pos;
  line(pos*2+2, 200, pos*2+2, 600);
  line(0, -max/div+500, ns*2, -max/div+500);
  println("error" +(orig-mes));
  max=0;
}

