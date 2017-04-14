import themidibus.*;

MidiBus myBus; // The MidiBus

float staffWidth = 600;
float staffHeight = 100;

ArrayList<ArrayList<Note>> notes = new ArrayList<ArrayList<Note>>();
int tick = 0;

int tempo = 76; //beats per minute

float lastTick = 0;

void setup() {
  size(800, 800);
  MidiBus.list();
  myBus = new MidiBus(this, "Ableton", "Real Time Sequencer");
}

void draw() {
  background(247, 202, 201, 1);

  //draw staff
  pushMatrix();
  translate(width/2 - staffWidth/2, height/2 - staffHeight/2);
  stroke(255);
  strokeWeight(1);
  noFill();
  for (int i = 0; i < 5; i++) {
    line(0, i * staffHeight/5.0, staffWidth, i * staffHeight/5.0);
  }
  popMatrix();

  //draw notes
  pushMatrix();
  noStroke();
  fill(255);
  translate(width/2 - staffWidth/2, height/2 - staffHeight/2);
  float startPoint = staffWidth/2 - notes.size() * 40.0 / 2.0;
  translate(startPoint, 0);
  for (int i = 0; i < notes.size(); i++) {
    for (int j = 0; j < notes.get(i).size(); j++) {
      drawNote(notes.get(i).get(j), i);
    }
  }
  popMatrix();

  //draw line
  //pushMatrix();
  //translate(width/2 - staffWidth/2, height/2 - staffHeight/2);
  //stroke(255);
  //line(tick*staffWidth/16,0, tick*staffWidth/16,staffHeight);
  //popMatrix();
  float elapsed = millis() - lastTick;
  if (elapsed > ((60*1000) / tempo)/4.0) {
    tick++;
    if (tick >= 16) {
      tick = 0;
      notes = new ArrayList<ArrayList<Note>>();
    }
    lastTick = millis();
  }
}

void noteOn(Note n) {
  if (tick >= notes.size()) {
    int times = notes.size();
    for (int i = 0; i < tick - times + 1; i++) {
      notes.add(new ArrayList<Note>());
    }
  }
  notes.get(tick).add(n);
}

void drawNote(Note n, int i) {
  float noteHeight = map(n.pitch, 28, 41, staffHeight * 0.8, 0);
  pushMatrix();
  translate(i*staffWidth/16, noteHeight);
  switch(n.channel) {
  case 0 :
    rotate(radians(-20));
    fill(0);
    noStroke();
    ellipse(0, 0, 20, 15);
    break;
  case 1 : 
    stroke(255);
    strokeWeight(1);
    line(0, 0, 20, 20);
    line(0, 20, 20, 0);
    break;
  case 2 :
    rotate(radians(45));
    noFill();
    stroke(146, 168, 209);
    strokeWeight(3);
    rect(0, 0, 20, 20);
    break;
  }
  popMatrix();
}