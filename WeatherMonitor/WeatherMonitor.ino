// Log air pressure and weather to an SD card. Low power!
#include <SD.h>
#include <Wire.h>
#include "BMP085.h"
#include "RTClib.h"

File logFile;
RTC_DS1307 rtc;
enum {green = 6, blue = 5, red = 7};

void setup()
{
    Serial.begin(38400);
    
    barometer.readEEPROM();
    barometer.setSLP(30);
    barometer.setOSS(0);
    
    rtc.begin();
    
    if(!rtc.isrunning())
    {
        Serial.println("RTC not running!");
        rtc.adjust(DateTime(__DATE__, __TIME__));
    }
    
    // LED pins
    pinMode(green, OUTPUT);
    pinMode(red, OUTPUT);
    pinMode(blue, OUTPUT);
    
    // Close file button
    pinMode(9, INPUT_PULLUP);
    
    // Set the chip select pin
    pinMode(10, OUTPUT);
    
    // Initialize the SD card
    SD.begin(10);
    
    // Open the master file thing and write initial data
    logFile = SD.open("weather.txt", FILE_WRITE);
    
    if(!logFile)
    {
        Serial.println("Error opening file for initial write!");
    }
    else
    {
    }
    
}

void loop()
{
    static unsigned long timestamp = 0, hbTimestamp = 0;
    int hbPeriod = 5;
    static int hb = 0, hbDir = 1;
    static bool writeData = false;
    
    // Process LEDs
    if(logFile && ~writeData)
    {
        digitalWrite(red, LOW);
        analogWrite(blue, 0);
        analogWrite(green, hb);
    }
    if(logFile && writeData)
    {
        digitalWrite(red, LOW);
        analogWrite(blue, hb);
        analogWrite(green, 0);
        
        if(millis() - timestamp > 1000)
            writeData = false;
    }
    if(!logFile)
    {
        digitalWrite(red, HIGH);
        analogWrite(blue, 0);
        analogWrite(green, 0);
    }
    if(micros() - hbTimestamp > hbPeriod * 1000)
    {
        // Increase or decrease the PWM period
        hb = hb + hbDir;
        
        if(hb == 255 || hb == 0)
            hbDir *= -1;
            
        hbTimestamp = micros();
    }
    
    
    // Check for rollover and fix it
    if(timestamp > millis())
    {
        timestamp = millis();
    }
    
    // Ready to write a new set of data
    if(millis() - timestamp > 5000)
    {
        writeData = true;
        DateTime now = rtc.now();
    
        // Get new barometer readings
        int i = 0;
        while(i<3)
        {
            i++;
            barometer.updatePTA();
            delay(40);
        }
        
        Serial.print("Pressure : ");
        Serial.print(barometer.pressure);
        Serial.print(" ");
        Serial.print("Temperature : ");
        Serial.println(barometer.temperature);
        
        Serial.print(now.year(), DEC);
        Serial.print('/');
        Serial.print(now.month(), DEC);
        Serial.print('/');
        Serial.print(now.day(), DEC);
        Serial.print(' ');
        Serial.print(now.hour(), DEC);
        Serial.print(':');
        Serial.print(now.minute(), DEC);
        Serial.print(':');
        Serial.print(now.second(), DEC);
        Serial.println();
        
        // Log data to SD card
        logFile.print(now.year(), DEC);
        logFile.print(',');
        logFile.print(now.month(), DEC);
        logFile.print(',');
        logFile.print(now.day(), DEC);
        logFile.print(',');
        logFile.print(now.hour(), DEC);
        logFile.print(',');
        logFile.print(now.minute(), DEC);
        logFile.print(',');
        logFile.print(now.second(), DEC);
        logFile.print(',');
        logFile.print(barometer.pressure);
        logFile.print(",");
        logFile.println(barometer.temperature);
        
        timestamp = millis();
    }    
    
    // Check if we need to close the file or not
    bool closeFile = digitalRead(9);
    if(closeFile == 0)
    {
        //Close the file since the pin is default pulled high
        logFile.close();
        Serial.println("Closing File");
    }
}
