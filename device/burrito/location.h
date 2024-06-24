#pragma once

#include <TinyGPS++.h>

// Try to read from the GPS serial for 'ms' milliseconds.
// If the satellite payload is complete, gps.encode returns true and
// so the function. gps.location.isValid should be true in this scenario.
// Returns false on timeout.
bool gps_delay(TinyGPSPlus* gps, unsigned long ms);
