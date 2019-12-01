/*
* Arduino LCD Tutorial
*
* Crated by Dejan Nedelkovski,
* www.HowToMechatronics.com
*
*/
#include <LiquidCrystal.h> // includes the LiquidCrystal Library 
LiquidCrystal lcd(2, 3, 4, 5, 6, 7); // Creates an LC object. Parameters: (rs, enable, d4, d5, d6, d7) 

int dirpin = 22;
int steppin = 23;

int red_light_pin = 43;
int blue_light_pin = 41;
int green_light_pin = 40;
bool done = false;

bool connected = false;

void setup() { 
  Serial3.begin(9600); 
  Serial.begin(9600);
  RGB_color(0, 255, 0);
  lcd.begin(16,2); // Initializes the interface to the LCD screen, and specifies the dimensions (width and height) of the display } 
  pinMode(dirpin, OUTPUT);
  pinMode(steppin, OUTPUT);
  Serial.println("wassup");
}
void loop() { 
  
  
//  Serial3.flush();
//
//  if (connected == false){
//    while(Serial3.available() == 0) {
//      
//    }
//  }
//  connected = true;
//  RGB_color(255,0,0);
//  
//  Serial3.readString();
//  Serial3.flush();
//
//  
//  String input = Serial3.readString(); 
//if (done == false) {
//  testData();
//  testData();
//  testData();
//  done = true;
//  
//}  
  testData();
  
  //Serial.println(Serial3.readString());
  //Serial.println(input);
  
//  int position = input
//  
//  int i;
//  for (i = 0l i<1; i++) {
//    turnMotor(
//  }
// 
// lcd.print("Arduino"); // Prints "Arduino" on the LCD 
// delay(3000); // 3 seconds delay 
// lcd.setCursor(2,1); // Sets the location at which subsequent text written to the LCD will be displayed 
// lcd.print("LCD Tutorial"); 
// delay(3000); 
// lcd.clear(); // Clears the display 
// lcd.blink(); //Displays the blinking LCD cursor 
// delay(4000); 
// lcd.setCursor(7,1); 
// delay(3000); 
// lcd.noBlink(); // Turns off the blinking LCD cursor 
// lcd.cursor(); // Displays an underscore (line) at the position to which the next character will be written 
// delay(4000); 
// lcd.noCursor(); // Hides the LCD cursor 
// lcd.clear(); // Clears the LCD screen 
}


void RGB_color(int red_light_value, int green_light_value, int blue_light_value)
 {
  analogWrite(red_light_pin, red_light_value);
  analogWrite(green_light_pin, green_light_value);
  analogWrite(blue_light_pin, blue_light_value);
 }
//

void testData() {
  String data = "1600,Arya,Blue"; 
  if (data != "Initialize") {
    RGB_color(255,0,0);
    int a = data.indexOf(',');
    String position = data.substring(0, a);
    String b = data.substring(a+1);
    int c = b.indexOf(',');
    String name1 = b.substring(0, c);
    String d = b.substring(c+1);
    int e = d.indexOf(',');
    String pill = d.substring(0, e);
    Serial.println(position);
    Serial.println(name1);
    Serial.println(pill);
//    Serial.print(position.toInt());
    TurnMotor(position.toInt()); 
    lcd.print(name1);
    lcd.setCursor(2,1);
    lcd.print(pill);
  }
}

void TurnMotor(int position) {
  int i;

  digitalWrite(dirpin, LOW);
  delay(100);

  for (i = 0; i<position; i++) {
    digitalWrite(steppin, LOW);
    digitalWrite(steppin, HIGH);
    delayMicroseconds(500);
  }

  
  delay(1000);
 }
