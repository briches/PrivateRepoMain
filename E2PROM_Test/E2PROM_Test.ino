void setup()
{
    Serial.begin(115200);
    Serial.println("\nHello!\n");
    
    long int testVal = -1100214;
    long int guess = 0;
    byte x[sizeof(testVal)/sizeof(byte)];
    
    Serial.print("The array is ");
    Serial.print(sizeof(testVal)/sizeof(byte));
    Serial.println(" bytes long.");
    
    Serial.println("The test value is: "); 
    Serial.println(testVal, BIN);
    
    for(int i = 0; i < sizeof(testVal); ++i)
    {
        x[i] = *((unsigned char *)&testVal + i);
    }
    
    Serial.println("The array is: ");
    Serial.println(x[0],BIN);
    Serial.println(x[1],BIN);
    Serial.println(x[2],BIN);
    Serial.println(x[3],BIN);
    
    Serial.println("Attempting to Combine");
    guess |= long(x[3]) << 24;
    guess |= long(x[2]) << 16;
    guess |= long(x[1]) << 8;
    guess |= long(x[0]);
    
    Serial.println(guess, BIN);
    
    if(guess == testVal) Serial.println("Pass!");
}

void loop()
{
    
}
