float pastVoltages[10];
int currentLoc = 0;

int hbPin = 6;

double speed;
double low = 1;
double high = 10;
double baseTime = 10;

double hbVal = 0;
int hbDir = 1;
int hbIncr = 5;
long int hbTimer = 0;

void setup()
{
        Serial.begin(9600);
        pinMode(7, OUTPUT);
        pinMode(hbPin, OUTPUT);
        
        Serial.println("Hello there, world!");
}



void heartbeat()
{
        if(millis() - hbTimer > 10)
        {
                        
                if(((hbVal + hbIncr * hbDir) > 255)  || ((hbVal + hbIncr * hbDir) < 0))
                {
                        hbDir = -hbDir;
                }
                
                if(hbDir == -1) 
                {
                        hbVal = hbVal - hbIncr;
                }
                else if(hbDir == 1)
                {
                        hbVal = hbVal + hbIncr;
                }
                
                analogWrite(hbPin, hbVal);
                
                hbTimer = millis();
        }
}

float read_SmoothAnalog()
{
        float result = 0;
        
        pastVoltages[currentLoc] = analogRead(0);
        currentLoc += 1;
        
        for(int i = 0; i<10; i++)
        {
                result += pastVoltages[i];
        }
        
        result /= 10;
        
        return map(result, 0, 920, 0, 10);
}

void loop()
{
        heartbeat();
        
        analogWrite(5, (speed/10)*255);
        
        speed = read_SmoothAnalog();
        
        
        Serial.println(speed);
        
        low = speed;
        high = baseTime - speed;        
}

