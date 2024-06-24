#include "location.h"
#include "display.h"
#include "constants.h"

bool gps_delay(TinyGPSPlus* gps, unsigned long ms) {
  unsigned long start = millis();
  do  {
    while (GPS_SERIAL.available() > 0) {
      byte read = GPS_SERIAL.read();
      // This debugging branch prints the NMEA in the programming serial
      if (DEBUG_GPS_NMEA) {
        Serial.print((char)read);
      }
      if (gps->encode(read)) {
        return true;
      }
    }
  } while (DEBUG_GPS_NMEA || millis() - start < ms);
  return false;
}
