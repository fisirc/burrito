#pragma once

#include <LiquidCrystal_I2C.h>
#include <DHT.h>
#include "constants.h"

/* Display related functions and custom char definitions */
#define CHAR_BURRITO1 "\x01"
#define CHAR_BURRITO2 "\x02"
#define CHAR_TEMP     "\x03"
#define CHAR_RAINDROP "\x04"
#define CHAR_WIFI     "\x05"
#define CHAR_NO_WIFI  "\x06"

void lcd_setup(LiquidCrystal_I2C* lcd);

void display_booting_up(LiquidCrystal_I2C* lcd, unsigned short step = 0);

void display_header(LiquidCrystal_I2C* lcd, const struct app_state* state, int row = 0);

void display_burrito_pos(
  LiquidCrystal_I2C* lcd,
  float lat = INVALID_COORD,
  float lng = INVALID_COORD,
  int row = 2
);

void display_weather(
  LiquidCrystal_I2C* lcd,
  float temp = INVALID_TEMPERATURE,
  float humidity = INVALID_HUMIDITY,
  int row = 3
);
