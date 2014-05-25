#include "SevenSegment.h"

disp7seg disp(100);

void setup()
{
    Serial.begin(115200);
    
    disp.setpins(4,5,6,7,8,9,10,11,2,3);
}

void loop()
{
    static unsigned long timestamp = 0;
    static int number = 0;
    
    disp.setdata(number);
    disp.update();
    
    if(millis() - timestamp > 10)
    {
        timestamp = millis();
        number ++;
        if(number == 99)
        number = 0;
    }
    
}
