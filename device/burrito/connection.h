#pragma once
#include <Arduino.h>
#include <LiquidCrystal_I2C.h>
#include "constants.h"

bool setup_wifi(LiquidCrystal_I2C* lcd, String ssid, String passwd);
bool send_data_to_server(const struct app_state* state, String endpoint);
bool wifi_is_connected();
