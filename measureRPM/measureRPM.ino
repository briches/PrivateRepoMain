// RPM Photodiode interface



void setup()
{
        Serial.begin(19200);
}

void loop()
{
        Serial.println(analogRead(0));
        delay(500);
}
