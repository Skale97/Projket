import processing.serial.*;

Serial myPort;       
byte bytes[];
int ibytes[]; 
int lbytes[];
int n = 0;
int d1 = 0;
int d2 = 0;
int cc = 0;


void setup() {
  bytes = new byte[5];
  ibytes = new int[5];
  lbytes = new int[5];
  size (1005, 600);
  println(myPort.list());
  frameRate(1000000);
  myPort = new Serial(this, Serial.list()[0], 256000);
}

void draw() {
  if (myPort.available() > 0) {
    n++;
    println(myPort.available());
    if (n>10001) {
      /*while (myPort.read () != 222) {
        println("JEESSS");
      }
      println("a"+myPort.available());
      int data1 = myPort.read();
      println("a"+myPort.available());
      int data2 = myPort.read();
      cc = data1*100+data2;
      println("CC: "+cc);
      println("a"+myPort.available());
      println(data1);
      println(data2);
      println("CC: "+(data1*100+data2));*/
      n = 0;
    }
    myPort.readBytesUntil(240, bytes);
    for (int i = 0; i<4; i++) {
      ibytes[i] = bytes[i];
      if (bytes[i]<0) ibytes[i]+=256;
      line((n-1)/10, lbytes[i]+i*150+100, n/10, ibytes[i]+i*150+100);
      lbytes[i] = ibytes[i];
    }
  }
}

void mousePressed() {
  n++;
  if (n==1) {
    d1 = mouseX;
    line(d1, 0, d1, height);
  } else if (n==2) {
    d2 = mouseX;
    line(d2, 0, d2, height);
    println("measured: "+(d2-d1));
    println("CC: "+cc);
  } else if (n==3) {
    background(255);
  }
}

