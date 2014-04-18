
/** Kalman Filter Library **/
/**
 @Author: Brandon Riches
 @Date: April 2014
**/

#ifndef KALMAN_H_INCLUDED
#define KALMAN_H_INCLUDED

using namespace std;






/* Kalman filter class type
*/

class kFilter
{
    public:

        // Constructor
        kFilter(int num);

        void addSensor(int ID, int context);

        // Sensor class, might not use
        class Sensor
        {
            public:
                // Constructor
                Sensor(int ID, int context);

                // What does the sensor measure
                enum{pos = 0, vel = 1, acc = 2};

            private:
                int measures;
                int id;
                bool active;
        };

    private:

        /** Private functions: **/
        void state2output();
        bool sensorExists(int ID);

        /** Private vars: **/
        // How many sensors does the filter manage
        static int numSensors;

        typedef struct
        {
            Sensor _sensor;

        } sensor_storage_t;

        // Output type, depends on number of sensors and the type of sensor
        typedef struct
        {

        } output_t;

        // State data type, depends on number of sensors and what not.
        typedef struct
        {

        } state_t;

        sensor_storage_t Sensors;
};

kFilter :: kFilter(int num)
{
    this->numSensors = num;
};

kFilter :: Sensor :: Sensor(int ID, int context)
{
    this->measures = context;
    this->id = ID;
    this->active = true;
};

bool kFilter :: sensorExists(int ID)
{
    bool validSensor = true;
    bool result = false;
    int sensorCount = 0;

    while(validSensor)
    {
        if(this->Sensors->sensorCount.inUse == true)
        {
            result = (ID == Sensors->sensorCount._sensor.ID);
        }

        if(result)
            return result;
    }

    return false;
};

void kFilter :: addSensor(int ID, int context)
{

};

#endif // KALMAN_H_INCLUDED
