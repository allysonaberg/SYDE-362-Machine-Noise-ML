//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
import java.util.Map;
import java.util.Iterator;
import java.util.Map.Entry;

OscP5 oscP5;
NetAddress dest;

//MOVING AVERAGE
float[] data1 = new float[2];
float total1 = 0, average1 = 0;
int m1 = 0, n1 = 0;

float[] data2 = new float[2];
float total2 = 0, average2 = 0;
int m2 = 0, n2 = 0;

float[] data3 = new float[2];
float total3 = 0, average3 = 0;
int m3 = 0, n3 = 0;

float[] data4 = new float[2];
float total4 = 0, average4 = 0;
int m4 = 0, n4 = 0;

float[] data5 = new float[2];
float total5 = 0, average5 = 0;
int m5 = 0, n5 = 0;

int decayStart = 200;
int decayAmount = 10;

float lowLim = 0.2;
float highLim = 0.8;

int decay1 = 200;
int decay2 = 200;
int decay3 = 200;
int decay4 = 200;
int decay5 = 200;

//DOT DATA
String lastNumber = "";
ArrayList<String> numbers = new ArrayList<String>();
HashMap<Float, Integer> collectedData = new HashMap<Float, Integer>();

boolean didChange = false;
boolean shouldAnimate = false;
float highlightColor = 255;
float backlightColor = 255;

//PI CHART DATA
HashMap<Integer, Float> angles = new HashMap<Integer, Float>();

float totalType1 = 0;
float totalType2 = 0;
float totalType3 = 0;
float totalType4 = 0;
float totalType5 = 0;

void setup()
{
  size(1000, 300);
  
  //Initialize OSC communication
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  rectMode(CENTER);
  
float[] numbers = {1,2,3,4,5,6,7,8,9,10};
  for(int i = 0; i < numbers.length; i++){
    nextValue1(numbers[i]);
    nextValue2(numbers[i]);
    nextValue3(numbers[i]);
    nextValue4(numbers[i]);
    nextValue5(numbers[i]);
  }  
}


// uses the moving averages to determine which block to light up
void draw()
{
  //persistent setup
    background(255);
    fill(0,0,0);
    textSize(20);
    
    text("Failure 1", 10, 68);
    text("Failure 2", 10, 128);
    text("Failure 3", 10, 188);
    text("Failure 4", 10, 248);
    
    
  if((average1 > highLim) && (average2 < lowLim) && (average3 < lowLim)  && (average4 < lowLim) && (average5 < lowLim)) {
    decay1 = decayStart;
    decay2 -= decayAmount;
    decay3 -= decayAmount;
    decay4 -= decayAmount;
    decay5 -= decayAmount;
  } else if((average1 < lowLim) && (average2 > highLim) && (average3 < lowLim) && (average4 < lowLim) && (average5 < lowLim)){
    decay1 -= decayAmount;
    decay2 = decayStart;
    decay3 -= decayAmount;
    decay4 -= decayAmount;
    decay5 -= decayAmount;
  } else if((average1 < lowLim) && (average2 < lowLim) && (average3 > highLim) && (average4 < lowLim) && (average5 < lowLim)){
    decay1 -= decayAmount;
    decay2 -= decayAmount;
    decay3 = decayStart;
    decay4 -= decayAmount;
    decay5 -= decayAmount;
  } else if((average1 < lowLim) && (average2 < lowLim) && (average3 < lowLim) && (average4 > highLim) && (average5 < lowLim)){
    decay1 -= decayAmount;
    decay2 -= decayAmount;
    decay3 -= decayAmount; 
    decay4 = decayStart;
    decay5 -= decayAmount;
  } else if((average1 < lowLim) && (average2 < lowLim) && (average3 < lowLim) && (average4 < lowLim) && (average5 > highLim)){
    decay1 -= decayAmount;
    decay2 -= decayAmount;
    decay3 -= decayAmount; 
    decay4 -= decayAmount;
    decay5 = decayStart;
  }
  
    if(decay1 < 0){decay1 = 0;}
    if(decay2 < 0){decay2 = 0;}
    if(decay3 < 0){decay3 = 0;}
    if(decay4 < 0){decay4 = 0;}
    if(decay5 < 0){decay5 = 0;}
    
    if (decay1 != 0 && (decay2 == 0) && (decay3 == 0) && (decay4 ==0)) {
      if (numbers.size() == 0 || (numbers.get(numbers.size() - 1) != "sound 1")) {
        numbers.add("sound 1");
        didChange = true;
        Float time = millis()/1000.0;
        collectedData.put(time,1);
        totalType1 = totalType1 + 1;
      } else {
        didChange = false;
      }
    } else if (decay2 != 0 && (decay1 == 0) && (decay3 == 0) && (decay4 ==0)) {
      if (numbers.size() == 0 || (numbers.get(numbers.size() - 1) != "sound 2")) {
        numbers.add("sound 2");
        didChange = true;
        Float time = millis()/1000.0;
        collectedData.put(time,2);
        totalType2 = totalType2 + 1;
      } else {
        didChange = false;
      }
    } else if (decay3 != 0 && (decay1 == 0) && (decay2 == 0) && (decay4 ==0)) {
      if (numbers.size() == 0 || (numbers.get(numbers.size() - 1) != "sound 3")) {
        numbers.add("sound 3");
        didChange = true;
        Float time = millis()/1000.0;
        collectedData.put(time,3);
        totalType3 = totalType3 + 1;
      } else {
        didChange = false;
      }
    } else if (decay4 != 0 && (decay1 == 0) && (decay2 == 0) && (decay3 ==0)) {
      if (numbers.size() == 0 || (numbers.get(numbers.size() - 1) != "sound 4")) {
        numbers.add("sound 4");
        Float time = millis()/1000.0;
        collectedData.put(time,4);
        totalType4 = totalType4 + 1;
        didChange = true;
      } else {
        didChange = false;
      }
    } else if (decay5 != 0 && (decay1 == 0) && (decay2 == 0) && (decay3 == 0) && (decay4 == 0)) {
      //ignore, this indicates white noise
      numbers.add("sound 5");
    }
    
    
    //IDEA: hold an array of past data, will keep updating. we will determine a "new" item when it no longer
    //matches the old item (there will need to be "white noise" between identical items to distinguish)
    //println(collectedData);
    for (Iterator<Entry<Float,Integer>> iter = collectedData.entrySet().iterator(); iter.hasNext();)
    {
      Entry<Float,Integer> timeStamp = iter.next();
      float value = timeStamp.getValue();
      noStroke();
      if (value == 1) {
        fill(255,0,0);
        ellipse(timeStamp.getKey()*10 + 100, value*60, 8, 8);
      } else if (value == 2) {
        fill(0,255,0);
        ellipse(timeStamp.getKey()*10 + 100, value*60, 8, 8);
      } else if (value == 3) {
        fill(0,0,255);
        ellipse(timeStamp.getKey()*10 + 100, value*60, 8, 8);
      } else if (value == 4) {
        fill(255,0,255);
        ellipse(timeStamp.getKey()*10 + 100, value*60, 8, 8);
      }
    }  
    println("");
        
    //PI CHART
    float totalNums = totalType1 + totalType2 + totalType3 + totalType4;

      if (totalNums > 0) {
      angles.clear();
      angles.put(1, (totalType1/totalNums)*360);
      angles.put(2, (totalType2/totalNums)*360);
      angles.put(3, (totalType3/totalNums)*360);
      angles.put(4, (totalType4/totalNums)*360);
    
      pieChart(200,angles);
    }
    
      
}

void pieChart(float diameter, HashMap<Integer,Float> data) {
    float lastAngle = 0;
    for (Iterator<Entry<Integer,Float>> iter = data.entrySet().iterator(); iter.hasNext();)
    {
      Entry<Integer,Float> errorType = iter.next();
      Integer error = errorType.getKey();
      noStroke();
      if (error == 1) {
        fill(255,0,0);
      } else if (error == 2) {
        fill(0,255,0);
      } else if (error == 3) {
        fill(0,0,255);
      } else if (error == 4) {
        fill(255,0,255);
      }
      arc(width/1.2, height/2, diameter, diameter, lastAngle, lastAngle+radians(errorType.getValue()));
      lastAngle += radians(errorType.getValue());
    }
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
     if(theOscMessage.checkTypetag("ffffff")) { //Now looking for parameters (6 being sent)
        float p1 = theOscMessage.get(0).floatValue(); //get first parameter
        float p2 = theOscMessage.get(1).floatValue(); //get second parameter
        float p3 = theOscMessage.get(2).floatValue(); //get third parameter
        float p4 = theOscMessage.get(3).floatValue(); //get fourth parameter
        float p5 = theOscMessage.get(4).floatValue(); //get fifth parameter
        
        nextValue1(p1);
        nextValue2(p2);
        nextValue3(p3);
        nextValue4(p4);
        nextValue5(p5);
        
        //println("Received new params value from Wekinator");  
      } else {
        println("Error: unexpected params type tag received by Processing");
      }
 }
}

// Use the next value and calculate the

// moving average1
public void nextValue1(float value){
  total1 -= data1[m1];
  data1[m1] = value;
  total1 += value;
  m1 = ++m1 % data1.length;
  if(n1 < data1.length) n1++;
  average1 = total1 / n1;
}

// moving average2
public void nextValue2(float value){
  total2 -= data2[m2];
  data2[m2] = value;
  total2 += value;
  m2 = ++m2 % data2.length;
  if(n2 < data2.length) n2++;
  average2 = total2 / n2;
}

// moving average3
public void nextValue3(float value){
  total3 -= data3[m3];
  data3[m3] = value;
  total3 += value;
  m3 = ++m3 % data3.length;
  if(n3 < data3.length) n3++;
  average3 = total3 / n3;
}

// moving average4
public void nextValue4(float value){
  total4 -= data4[m4];
  data4[m4] = value;
  total4 += value;
  m4 = ++m4 % data4.length;
  if(n4 < data4.length) n4++;
  average4 = total4 / n4;
}

// moving average5
public void nextValue5(float value){
  total5 -= data5[m5];
  data5[m5] = value;
  total5 += value;
  m5 = ++m5 % data5.length;
  if(n5 < data5.length) n5++;
  average5 = total5 / n5;
}