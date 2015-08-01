import processing.serial.*;

int dirlen = 20;
int dirMem[][] = {
  {
    1, 0, 0
  }
  , {
    2, 0, 0
  }
  , {
    -1, 0, 0
  }
  , {
    -2, 0, 0
  }
  ,{
    0, 1, 0
  }
  , {
    0, -1, 0
  }
  , {
    0, 0, 1
  }
  , {
    0, 0, -1
  }
  , {
    1, 1, 0
  }
  , {
    1, -1, 0
  }
  , {
    -1, 1, 0
  }
  , {
    -1, -1, 0
  }
  , {
    1, 0, 1
  }
  , {
    1, 0, -1
  }
  , {
    -1, 0, 1
  }
  , {
    -1, 0, -1
  }
  , {
    0, 1, 1
  }
  , {
    0, 1, -1
  }
  , {
    0, -1, 1
  }
  , {
    0, -1, -1
  }
};
int x[] = { 
  500, 0, 1000, 500
};
int y[] = {
  0, 550, 560, 1000
};
int z[] = {
  0, 1000, 1000, 0
};
float mesDist[] = {
  0, 0, 0, 0
};
float est[] = {
  0, 0, 0, 0
};
int sine[][];
Boolean start = true;
float best = 0;
int bestxyz[] = {
  0, 0, 0
};
int estxyz[] = {
  0, 0, 0
};
int lastxyz[] = {
  0, 0, 0
};
float locmin = 0;
int dir = 0;
int once = 0;

int n = 0;
int broj = 1;

int xm = 80;
int ym = 40;
int zm = 60;

PrintWriter outputcc;
PrintWriter outputd;
Serial myPort;   
int Buff[] = new int[40000];

void setup() {
  size(100,100);
  ellipseMode(CENTER);
  frameRate(40);
  for (int i = 0; i<3; i++) {
    estxyz[i] = 0;
    lastxyz[i] = 0;
  }
  locmin = 0;
  dir = 0;
  once = 0;
  myPort = new Serial(this, Serial.list()[0], 256000);
  outputd = createWriter("M-x"+xm+"y"+ym+"z"+zm+"data.txt");
  outputd.println("Position [cm]:");
  outputd.println("x: "+xm+"cm, y: "+ym+"cm, z: "+zm+"cm");
}


void draw() {
  if (myPort.available()>=40009) {
    record(); 
    if (broj == 4) {
      exit();
      outputd.flush();
      outputd.close();
    }
  }
}


void record() {
  outputcc = createWriter("M-x"+xm+"y"+ym+"z"+zm+"b"+broj+"cc.txt");
  broj++;
  float cc1 = 0, cc2 = 0, cc3 = 0; 
  int bytes = 0;
  int proc = 0;
  for (int i = 0; i<40000; i++) {
    outputcc.print(myPort.read() + " ");
  }
  outputcc.flush();
  outputcc.close();
  bytes = myPort.read();
  cc1 = myPort.read()*100+myPort.read();
  bytes = myPort.read();
  cc2 = myPort.read()*100+myPort.read();
  bytes = myPort.read();
  cc3 = myPort.read()*100+myPort.read();
  bytes = myPort.read();
  //println("cc1 "+cc1+" cc2 "+cc2+" cc3 "+cc3); 
  outputd.println("Results for measurment number "+(broj-1));
  outputd.println("Cross correlation 1 result:");
  outputd.println("raw: "+cc1);
  outputd.println("In cm: "+((cc1-500)*0.34)); 
  outputd.println("Cross correlation 2 result:");
  outputd.println("raw: "+cc2);
  outputd.println("In cm: "+((cc2-500)*0.34));
  outputd.println("Cross correlation 3 result:");
  outputd.println("raw: "+cc3);
  outputd.println("In cm: "+((cc3-500)*0.34));
  outputd.println();
  for (int i = 0; i<3; i++) {
    bestxyz[i] = 0;
    lastxyz[i] = 0;
    estxyz[i] = int(random(0, 400));
  }
  locmin = 0;
  dir = 0;
  once = 0;
  best = 0;
  mesDist[0] = 0;
  mesDist[1] = ((cc1-500)*3.4);
  mesDist[2] = ((cc2-500)*3.4);
  mesDist[3] = ((cc3-500)*3.4);
  distRandomPoint();
  estimate();
  outputd.println("Gradient descent results:");
  outputd.println("x: "+estxyz[0]/10+"cm, y: "+estxyz[1]/10+"cm, z: "+estxyz[2]/10+"cm"); 
  outputd.println("Error:");
  outputd.println("x: "+abs(estxyz[0]/10-xm)+"cm, y: "+abs(estxyz[1]/10-ym)+"cm, z: "+abs(estxyz[2]/10-zm)+"cm");
  outputd.println("Distance error: "+dist(estxyz[0]/10, estxyz[1]/10, estxyz[2]/10, xm, ym, zm)+"cm");
  outputd.println();
  println("Estimated: x: "+bestxyz[0]/10+"cm, y: "+bestxyz[1]/10+"cm, z: "+bestxyz[2]/10+"cm");
}


void distRandomPoint() { //Računa rastojanje za random tačku
  for (int i = 0; i<4; i++) {
    est[i] = dist(estxyz[0], estxyz[1], estxyz[2], x[i], y[i], z[i]);
  }
  est[3] -= est[0];
  est[2] -= est[0];
  est[1] -= est[0];
  est[0] -= est[0];
}


void estimate() { //Vrši estimaciju položaja izvora
  best = 0;
  once = 0;
  distRandomPoint();
  best = err();
  for (int j = 0; j<6; j++) {
    for (int i = 0; i<3; i++) {
      lastxyz[i] = -1000;
      estxyz[i] = int(random(0, 400));
    }
    Boolean gotovo = false;
    while (!gotovo) {
      direction();
      if (!(lastxyz[0]==estxyz[0] && lastxyz[1]==estxyz[1] && lastxyz[2]==estxyz[2])) {
        if (once == 1) {
          for (int i = 0; i<3; i++)
            lastxyz[i] = estxyz[i];
        } else if (once == 3) {
          once = 0;
        }
        once++;
        estxyz[0] += dirMem[dir][0];
        estxyz[1] += dirMem[dir][1];
        estxyz[2] += dirMem[dir][2];
      } else {
        gotovo=true;
        distRandomPoint();
        locmin = err();
        if (locmin<best) {
          best = locmin;
          for (int i = 0; i<3; i++)
            bestxyz[i] = estxyz[i];
        }
      }
    }
  }
}

void direction() { //Određuje smer kretanja u smeru smanjenja greke

  distRandomPoint();

  locmin = err();

  for (int i = 0; i<dirlen; i++) {
    estxyz[0] += dirMem[i][0];
    estxyz[1] += dirMem[i][1];
    estxyz[2] += dirMem[i][2];

    distRandomPoint();
    if (err()<locmin) {
      locmin=err();
      dir=i;
    }
    estxyz[0] -= dirMem[i][0];
    estxyz[1] -= dirMem[i][1];
    estxyz[2] -= dirMem[i][2];
  }
}

float err() {
  return sq(est[1]-mesDist[1]) + sq(est[2]-mesDist[2]) + sq(est[3]-mesDist[3]);
}

