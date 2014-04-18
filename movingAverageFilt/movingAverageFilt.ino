void setup()
{
        Serial.begin(115200);
}
const int filtSize = 1;
double filter[filtSize];
int here = 0;
void loop()
{
        filter[here] = analogRead(0);
        double sum;
        here++;
        if(here == filtSize) here = 0;
        for(int i = 0; i < filtSize; i++)
        {
                sum += filter[i];
        }
        double value = sum / filtSize;
        Serial.println(value);
        
        delay(100);
}
