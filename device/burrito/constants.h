#pragma once

struct app_state {
  float lat;
  float lng;
  float temp;
  float humidity;
  bool  wifi_connected;
  bool  gps_error;
  bool  gps_loading;
  int   gps_error_tries;
};

#define APP_TITLE "Burrito!"

#define LOOP_DELAY 500
#define LED_PORT 2

/* Semantic values */

#define INVALID_TEMPERATURE -273.0f
#define INVALID_HUMIDITY    -1.0f

/* 20x4 LCD Configuration */
#define I2C_ADDR    0x27
#define LCD_COLUMNS 20
#define LCD_LINES   4

/* DHT22 Configuration */
#define DHT22_PORT 5

/* neo6m GPS Configuration */
#define RXD2 16
#define TXD2 17
#define GPS_SERIAL Serial2
// Set to true if you want to see the raw NMEA satellite data
#define DEBUG_GPS_NMEA true
#define MAX_GPS_ERROR_TRIES 5
