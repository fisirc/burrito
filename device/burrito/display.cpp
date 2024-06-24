#include <cstdint>
#include <Arduino.h>
#include "display.h"
#include "constants.h"

void display_booting_up(LiquidCrystal_I2C* lcd, unsigned short step) {
  lcd->setCursor(2 + step, 1);
  lcd->print("." CHAR_BURRITO1 CHAR_BURRITO2);
  lcd->setCursor(5, 2);
  lcd->print("Booting up");
}

void display_header(LiquidCrystal_I2C* lcd, const struct app_state* state, int row) {
  lcd->setCursor(0, row);
  lcd->print(APP_TITLE);
  lcd->setCursor(LCD_COLUMNS - 1, row);
  if (state->wifi_connected) {
    lcd->print(CHAR_WIFI);
  }
  else {
    lcd->print(" ");
  }
}

void display_burrito_pos(LiquidCrystal_I2C* lcd, float lat, float lng, int row) {
  String s_lat = String(lat, 3);
  String s_lng = String(lng, 3);
  lcd->setCursor(0, row);
  lcd->print(CHAR_BURRITO1 CHAR_BURRITO2 " ");

  if (lat == INVALID_COORD || lng == INVALID_COORD) {
    lcd->print("error!           ");
  }
  else if (lat == LOADING_COORD || lng == LOADING_COORD) {
    lcd->print("loading...       ");
  }
  else {
    lcd->print("(");
    lcd->print(s_lat);
    lcd->print(",");
    lcd->print(s_lng);
    lcd->print(")");
  }
}

void display_weather(LiquidCrystal_I2C* lcd, float temp, float humidity, int row) {
  lcd->setCursor(0, row);
  lcd->print(CHAR_TEMP" ");

  if (temp == INVALID_TEMPERATURE) {
    lcd->print(" -- ");
  }
  else {
    lcd->print(temp);
    lcd->print("C ");
  }

  lcd->setCursor(9, row);
  lcd->print("  "CHAR_RAINDROP" ");
  if (humidity == INVALID_HUMIDITY) {
    lcd->print(" -- ");
  }
  else {
    lcd->print(humidity);
    lcd->print("% ");
  }
}

/* 🔠 Custom characters data */

static uint8_t custom_char_burrito1[8] = {
  0b00000,
  0b00000,
  0b11111,
  0b10101,
  0b11111,
  0b11111,
  0b01000,
  0b00000,
};
static uint8_t custom_char_burrito2[8] = {
  0b00000,
  0b00000,
  0b11111,
  0b10100,
  0b11111,
  0b11111,
  0b00010,
  0b00000,
};
static uint8_t custom_char_temperature[8] = {
  0b00100,
  0b01010,
  0b01010,
  0b01010,
  0b01010,
  0b10001,
  0b10001,
  0b01110,
};
static uint8_t custom_char_raindrop[8] = {
  0b00100,
  0b01110,
  0b01110,
  0b11111,
  0b11111,
  0b11111,
  0b11111,
  0b01110,
};
static uint8_t custom_char_wifi[8] = {
  0b00000,
  0b01110,
  0b10001,
  0b00100,
  0b01010,
  0b00000,
  0b00100,
  0b00000,
};

void lcd_setup(LiquidCrystal_I2C* lcd) {
  lcd->init();
  lcd->backlight();
  lcd->createChar(0x01, custom_char_burrito1);
  lcd->createChar(0x02, custom_char_burrito2);
  lcd->createChar(0x03, custom_char_temperature);
  lcd->createChar(0x04, custom_char_raindrop);
  lcd->createChar(0x05, custom_char_wifi);
}
