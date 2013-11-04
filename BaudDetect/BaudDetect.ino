boolean risingDetect = false;

unsigned long transition, timer, shortestTransition; 
unsigned long byteTime;
int bitCount;


void myISR(void)
{
        risingDetect = true;
}

void setup(void)
{
        attachInterrupt(0, myISR, RISING);
        Serial.begin(19200);
}

void loop(void)
{
        if(risingDetect)
        {
                unsigned long time = micros();
                transition = time - timer;
                timer = time;
                
                
                if(transition < shortestTransition)
                {
                        shortestTransition = transition;
                }
                
                bitCount += 1;
                
                
                
                risingDetect = false;
                
                byteTime += transition;
                
                if(bitCount == 9)
                {
                        Serial.println(byteTime);
                        bitCount = 0;
                        byteTime = 0;
                }
        }
}
