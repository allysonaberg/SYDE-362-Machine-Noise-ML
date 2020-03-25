//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
import java.util.Map;
import java.util.Iterator;
import java.util.Map.Entry;

OscP5 oscP5;
NetAddress dest;

float lowLim = 0.2;
float highLim = 0.8;

float p1 = 0;
float p2 = 0;
float p3 = 0;
float p4 = 0;
float p5 = 0;

//DOT DATA

HashMap<Float, Integer> collectedData = new HashMap<Float, Integer>();
HashMap<Float, Float> timeStampData = new HashMap<Float, Float>();

float startTime = 0.0;
float highlightColor = 255;
float backlightColor = 255;

color pink = color(255,159,247);
color green = color(0,250,0);
color yellow = color(252,211,0);
color blue = color(49,201,251);

//PI CHART DATA
HashMap<Integer, Float> angles = new HashMap<Integer, Float>();

float totalType1 = 0;
float totalType2 = 0;
float totalType3 = 0;
float totalType4 = 0;
float totalType5 = 0;

String previous = "";

// CSV
Table table = new Table();

void setup()
{
  frameRate(100);
  size(1000, 550);
  
  //Initialize OSC communication
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  rectMode(CENTER);
  
  table.addColumn("timestamp");
  table.addColumn("sound");
  
}


// uses the moving averages to determine which block to light up
void draw()
{
  // ******** PERSISTENT SETUP ******* //
  
    background(0);
    fill(0);
    textSize(15);
    
    fill(pink);
    text("Failure 1", 20, 68);
    fill(green);
    text("Failure 2", 20, 128);
    fill(yellow);
    text("Failure 3", 20, 188);
    fill(blue);
    text("Failure 4", 20, 248);
    fill(255);
    rect(800, 430, 150, 50); 
    fill(0);
    text("Generate CSV", 748, 435);

    
    fill(255);
    rect(520, height/2+1, 800,1);
    //30*num + 150
    textSize(12);
    text("0", 150, height/2 + 20);
    text("1", 180, height/2 + 20);
    text("2", 210, height/2 + 20);
    text("3", 240, height/2 + 20);
    text("4", 270, height/2 + 20);
    text("5", 300, height/2 + 20);
    text("6", 330, height/2 + 20);
    text("7", 360, height/2 + 20);
    text("8", 390, height/2 + 20);
    text("9", 420, height/2 + 20);
    text("10", 450, height/2 + 20);
    text("11", 480, height/2 + 20);
    text("12", 510, height/2 + 20);
    text("13", 540, height/2 + 20);
    text("14", 570, height/2 + 20);
    text("15", 600, height/2 + 20);
    text("16", 630, height/2 + 20);
    text("17", 660, height/2 + 20);
    text("18", 690, height/2 + 20);
    text("19", 720, height/2 + 20);
    text("20", 750, height/2 + 20);
    text("time", 930, height/2 + 6);
    update();
    
    
    if ((p1 > highLim) && (p2 < lowLim) && (p3 < lowLim) && (p4 < lowLim) && (p5 < lowLim)) {
          if (previous != "A") {        
            if (collectedData.size() == 0) {
            startTime = millis()/1000.0;
            }
            
            Float time = millis()/1000.0 - startTime;
            collectedData.put(time,1);
            totalType1 = totalType1 + 1;
            
            TableRow newRow = table.addRow();
            newRow.setString("sound", "A");
            newRow.setFloat("timestamp", time);
            previous = "A";
          }
        } else if ((p1 < lowLim) && (p2 > highLim) && (p3 < lowLim) && (p4 < lowLim) && (p5 < lowLim)) {
          if (previous != "B") {
            if (collectedData.size() == 0) {
            startTime = millis()/1000.0;
            }
            
            Float time = millis()/1000.0 - startTime;
            collectedData.put(time,2);
            totalType2 = totalType2 + 1;
            
            TableRow newRow = table.addRow();
            newRow.setString("sound", "B");
            newRow.setFloat("timestamp", time);
            previous = "B";
          }
        } else if ((p1 < lowLim) && (p2 < lowLim) && (p3 > highLim) && (p4 < lowLim) && (p5 < lowLim)) {
          if (previous != "C") {
            if (collectedData.size() == 0) {
            startTime = millis()/1000.0;
            }
            
            Float time = millis()/1000.0 - startTime;
            collectedData.put(time,3);
            totalType3 = totalType3 + 1;
            
            TableRow newRow = table.addRow();
            newRow.setString("sound", "C");
            newRow.setFloat("timestamp", time);
            previous = "C";
          }
        } else if ((p1 < lowLim) && (p2 < lowLim) && (p3 < lowLim) && (p4 > highLim) && (p5 < lowLim)) {
          if (previous != "D") {
            if (collectedData.size() == 0) {
            startTime = millis()/1000.0;
            }
            
            Float time = millis()/1000.0 - startTime;
            collectedData.put(time,4);
            totalType4 = totalType4 + 1;
            
            TableRow newRow = table.addRow();
            newRow.setString("sound", "D");
            newRow.setFloat("timestamp", time);
            previous = "D";
          }
        } else if ((p1 < lowLim) && (p2 < lowLim) && (p3 < lowLim) && (p4 < lowLim) && (p5 > highLim)) {
         if (previous != "-") {
            TableRow newRow = table.addRow();
            newRow.setString("sound", "-");
            previous = "-";
          } 
        }
        
    for (Iterator<Entry<Float,Integer>> iter = collectedData.entrySet().iterator(); iter.hasNext();)
    {
      Entry<Float,Integer> timeStamp = iter.next();
      float value = timeStamp.getValue();
      noStroke();
      if (value == 1) {
        fill(pink);
        ellipse(timeStamp.getKey()*30 + 150, value*60, 12, 12);
        timeStampData.put(timeStamp.getKey()*30 + 150, value*60);
      } else if (value == 2) {
        fill(green);
        ellipse(timeStamp.getKey()*30 + 150, value*60, 12, 12);
        timeStampData.put(timeStamp.getKey()*30 + 150, value*60);
      } else if (value == 3) {
        fill(yellow);
        ellipse(timeStamp.getKey()*30 + 150, value*60, 12, 12);
        timeStampData.put(timeStamp.getKey()*30 + 150, value*60);
      } else if (value == 4) {
        fill(blue);
        ellipse(timeStamp.getKey()*30 + 150, value*60, 12, 12);
        timeStampData.put(timeStamp.getKey()*30 + 150, value*60);
      }
    }  
        
        
    // ******* PI CHART *******//
    
    float totalNums = totalType1 + totalType2 + totalType3 + totalType4;
      textSize(13);
      fill(255);
      text("Failure Type", width/18 + 120, height/1.4 - 30);
      text("Count", width/18 + 270, height/1.4 - 30);
      noStroke();
      rect(width/18 + 225, height/1.4 - 20, 210, 1);
      fill(pink);
      text("Failure 1", width/18 + 130, height/1.4);
      fill(255);
      text(int(totalType1), width/18 + 280, height/1.4);
      fill(green);
      text("Failure 2", width/18 + 130, height/1.4 + 30);
      fill(255);
      text(int(totalType2), width/18 + 280, height/1.4 + 30);
      fill(yellow);
      text("Failure 3", width/18 + 130, height/1.4 + 60);
      fill(255);
      text(int(totalType3), width/18 + 280, height/1.4 + 60);
      fill(blue);
      text("Failure 4", width/18 + 130, height/1.4 + 90);
      fill(255);
      text(int(totalType4), width/18 + 280, height/1.4 + 90);
      
      if (totalNums > 0) {
      angles.clear();
      angles.put(1, (totalType1/totalNums)*360);
      angles.put(2, (totalType2/totalNums)*360);
      angles.put(3, (totalType3/totalNums)*360);
      angles.put(4, (totalType4/totalNums)*360);
    
      pieChart(200,angles, int(totalNums));
    }
    
}

void pieChart(float diameter, HashMap<Integer,Float> data, int total) {
    float lastAngle = 0;
    for (Iterator<Entry<Integer,Float>> iter = data.entrySet().iterator(); iter.hasNext();)
    {
      Entry<Integer,Float> errorType = iter.next();
      Integer error = errorType.getKey();
      noStroke();
      if (error == 1) {
        fill(pink);
      } else if (error == 2) {
        fill(green);
      } else if (error == 3) {
        fill(yellow);
      } else if (error == 4) {
        fill(blue);
      }
      arc(width/3+180, height/1.3, diameter, diameter, lastAngle, lastAngle+radians(errorType.getValue()));
      lastAngle += radians(errorType.getValue());
      
      fill(255,255,255);
      ellipse(width/3+180, height/1.3,90,90);
      fill(0);
      textSize(12);
      text("total failures", width/3 +145, height/1.32 - 10);
      textSize(20);
      text(total, width/3+170, height/1.32 + 18);
    }
}

void update() {
  //for position in positions
  
  for (Iterator<Entry<Float,Float>> iter = timeStampData.entrySet().iterator(); iter.hasNext();)
  {
    Entry<Float,Float> vals = iter.next();
    float positionX = vals.getKey();
    float positionY = vals.getValue();
    if (overPoint(positionX, positionY, 12.0)) {
      //draw label with time
      float time = (positionX - 150.0)/30.0;
      text(nf(time,0,2) + "s", positionX-15, positionY-15);
    }
  }
}

void mousePressed() {
//coords: x: 725 -> 875 and y: 405 -> 455
if ((mouseX > 725 && mouseX < 875) && (mouseY > 405 && mouseY < 455)) {
      saveTable(table, "data/timestamps.csv");
  }
}

//SOURCE: https://processing.org/examples/rollover.html
boolean overPoint(float x, float y, float bound) {
  if (x > (mouseX - bound) && (x < mouseX + bound)) {
    if (y > (mouseY - bound) && y < (mouseY + bound)) {
      return true;
    }
    else {
      return false;
    }
  }
  else {
    return false;
  }
}
//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
     if(theOscMessage.checkTypetag("ffffff")) { //Now looking for parameters (6 being sent)
        p1 = theOscMessage.get(0).floatValue(); //get first parameter
        p2 = theOscMessage.get(1).floatValue(); //get second parameter
        p3 = theOscMessage.get(2).floatValue(); //get third parameter
        p4 = theOscMessage.get(3).floatValue(); //get fourth parameter
        p5 = theOscMessage.get(4).floatValue(); //get fifth parameter

        
        //println("Received new params value from Wekinator");  
      } else {
        println("Error: unexpected params type tag received by Processing");
      }
 }
}
