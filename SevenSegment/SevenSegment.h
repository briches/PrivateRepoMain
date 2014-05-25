#ifndef SEVENSEGMENT_H
#define SEVENSEGMENT_H

#include "Arduino.h"
#include <math.h>

class disp7seg
{
    public:
        disp7seg(long freq);
        void setpins(int apin_, int bpin_, int cpin_, int dpin_, int epin_, int fpin_, int gpin_, int dppin_, int en1pin_, int en2pin_);
        void setdata(int data);
        void update(void);
    
    private:
        // Keep track of which digit was written to last
        int state;
        
        // Value of digit1
        int digit1;
        
        // Value of digit2
        int digit2;
        
        // The state of each segment
        bool A,B,C,D,E,F,G,DP,EN1,EN2;
        
        // The pins to write to
        int apin, bpin, cpin, dpin, epin, fpin, gpin, dppin, en1pin, en2pin;
        
        unsigned long timestamp; // Timestamp in microseconds
        
        unsigned long period; // Period in microseconds, 10000 us = 100 Hz
        
        void set0(void);
        void set1(void);
        void set2(void);
        void set3(void);
        void set4(void);
        void set5(void);
        void set6(void);
        void set7(void);
        void set8(void);
        void set9(void);
};

disp7seg :: disp7seg(long freq)
{
    this->period = 1000000.0/(freq);
    this->state = 1;
};

void disp7seg :: update(void)
{
    if(micros() - timestamp > period)
    {
        if(state == 2)
        {
            digitalWrite(en2pin, LOW); // Turn off digit two
            digitalWrite(en1pin, HIGH); // Turn on digit one
            switch(digit1)
            {
                case 0:
                    set0();
                    break;
                case 1:
                    set1();
                    break;
                case 2:
                    set2();
                    break;
                case 3:
                    set3();
                    break;
                case 4:
                    set4();
                    break;
                case 5:
                    set5();
                    break;
                case 6:
                    set6();
                    break;
                case 7:
                    set7();
                    break;
                case 8:
                    set8();
                    break;
                case 9:
                    set9();
                    break;
            }
        } // State == 2
        if(state == 1)
        {
            digitalWrite(en1pin, LOW); // Turn off digit one
            digitalWrite(en2pin, HIGH); // Turn on digit two
            switch(digit2)
            {
                case 0:
                    set0();
                    break;
                case 1:
                    set1();
                    break;
                case 2:
                    set2();
                    break;
                case 3:
                    set3();
                    break;
                case 4:
                    set4();
                    break;
                case 5:
                    set5();
                    break;
                case 6:
                    set6();
                    break;
                case 7:
                    set7();
                    break;
                case 8:
                    set8();
                    break;
                case 9:
                    set9();
                    break;
            }
        } // State == 1
        digitalWrite(apin, A);
        digitalWrite(bpin, B);
        digitalWrite(cpin, C);
        digitalWrite(dpin, D);
        digitalWrite(epin, E);
        digitalWrite(fpin, F);
        digitalWrite(gpin, G);
        digitalWrite(dppin, DP);
        timestamp = micros();
        state = (state == 1) * 2 + (state == 2) * 1;
    } // micros - timestamp > period
};

void disp7seg::setdata(int data)
{
    if(data < 0)
        data = abs(data);
    if(data > 99)
        data = 99;
        
    digit1 = data%10;
    data /= 10;
    digit2 = data%10;
    Serial.println("Changing digits!");
    Serial.print("Digit 1: "); Serial.print(digit1);
    Serial.print(" Digit 2: "); Serial.println(digit2);
};

void disp7seg::setpins(int apin_, int bpin_, int cpin_, int dpin_, int epin_, int fpin_, int gpin_, int dppin_, int en1pin_, int en2pin_)
{
    pinMode(apin_, OUTPUT);
    pinMode(bpin_, OUTPUT);
    pinMode(cpin_, OUTPUT);
    pinMode(dpin_, OUTPUT);
    pinMode(epin_, OUTPUT);
    pinMode(fpin_, OUTPUT);
    pinMode(gpin_, OUTPUT);
    pinMode(dppin_, OUTPUT);
    pinMode(en1pin_, OUTPUT);
    pinMode(en2pin_, OUTPUT);
    
    apin = apin_;
    bpin = bpin_;
    cpin = cpin_;
    dpin = dpin_;
    epin = epin_;
    fpin = fpin_;
    gpin = gpin_;
    dppin = dppin_;
    en1pin = en1pin_;
    en2pin = en2pin_;
    
    A = !false;
    B = !false;
    C = !false;
    D = !false;
    E = !false;
    F = !false;
    G = !false;
    DP = !false;
    EN1 = false;
    EN2 = false;
    
    digitalWrite(apin,A);
    digitalWrite(bpin,B);
    digitalWrite(cpin,C);
    digitalWrite(dpin,D);
    digitalWrite(epin,E);
    digitalWrite(fpin,F);
    digitalWrite(gpin,G);
    digitalWrite(dppin,DP);
    
};

void disp7seg::set0()
{
    A = !true;
    B = !true;
    C = !true;
    D = !true;
    E = !true;
    F = !true;
    G = !false;
};
void disp7seg::set1()
{
    A = !false;
    B = !true;
    C = !true;
    D = !false;
    E = !false;
    F = !false;
    G = !false;
};
void disp7seg::set2()
{
    A = !true;
    B = !true;
    C = !false;
    D = !true;
    E = !true;
    F = !false;
    G = !true;
};
void disp7seg::set3()
{
    A = !true;
    B = !true;
    C = !true;
    D = !true;
    E = !false;
    F = !false;
    G = !true;
};
void disp7seg::set4()
{
    A = !false;
    B = !true;
    C = !true;
    D = !false;
    E = !false;
    F = !true;
    G = !true;
};
void disp7seg::set5()
{
    A = !true;
    B = !false;
    C = !true;
    D = !true;
    E = !false;
    F = !true;
    G = !true;
};
void disp7seg::set6()
{
    A = !true;
    B = !false;
    C = !true;
    D = !true;
    E = !true;
    F = !true;
    G = !true;
};
void disp7seg::set7()
{
    A = !true;
    B = !true;
    C = !true;
    D = !false;
    E = !false;
    F = !false;
    G = !false;
};
void disp7seg::set8()
{
    A = !true;
    B = !true;
    C = !true;
    D = !true;
    E = !true;
    F = !true;
    G = !true;
};
void disp7seg::set9()
{
    A = !true;
    B = !true;
    C = !true;
    D = !true;
    E = !false;
    F = !true;
    G = !true;
};


#endif
