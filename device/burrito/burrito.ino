#include "display.h"
#include "constants.h"
#include "location.h"
#include "connection.h"

String var_wifi_ssid     = "the_hot_spot";
String var_wifi_password = "delunoalnueve";
//String var_burrito_host  = "https://burrito-server.shuttleapp.rs";
String var_burrito_host  = "http://143.198.141.62:6969";
String var_burrito_post  = "/give-position/";

LiquidCrystal_I2C lcd(I2C_ADDR, LCD_COLUMNS, LCD_LINES);
DHT dht22(DHT22_PORT, DHT22);
TinyGPSPlus gps;

struct app_state state;

/* 🚌 Burrito setup code */

void setup() {
  state = {
    .lat = 0.0f,
    .lng = 0.0f,
    .temp = INVALID_TEMPERATURE,
    .humidity = INVALID_HUMIDITY,
    .wifi_connected = false,
    .gps_error = false,
    .gps_loading = true,
    .gps_error_tries = 0,
  };

  Serial.begin(115200);
  Serial.print("Burrito tracker started\n");

  lcd_setup(&lcd);
  display_booting_up(&lcd, 0);

  pinMode(LED_PORT, OUTPUT);
  GPS_SERIAL.begin(9600, SERIAL_8N1, RXD2, TXD2);
  dht22.begin();
  state.wifi_connected = setup_wifi(&lcd, var_wifi_ssid, var_wifi_password);
  lcd.clear();
}

/* 🚌 Burrito loop code */

bool error_reported = false;

void loop() {
  bool gps_ready = gps_delay(&gps, 1000);
  state.wifi_connected = wifi_is_connected();

  state.temp = dht22.readTemperature();
  state.humidity = dht22.readHumidity();
  if (isnan(state.temp)) {
    state.temp = INVALID_TEMPERATURE;
  }
  if (isnan(state.humidity)) {
    state.humidity = INVALID_HUMIDITY;
  }

  bool has_gps_data = gps_ready && gps.location.isValid();

  if (has_gps_data) {
    state.lat = gps.location.lat();
    state.lng = gps.location.lng();
    state.gps_error_tries = 0;
    state.gps_error = false;
    state.gps_loading = false;
  } else if (!state.gps_loading) {
    state.gps_error_tries++;
    if (state.gps_error_tries > MAX_GPS_ERROR_TRIES) {
      state.gps_error_tries = 0;
      state.gps_error = true;
      ESP.restart();
    }
  }

  display_header(&lcd, &state);
  display_burrito_pos(&lcd, &state);
  display_weather(&lcd, state.temp, state.humidity);

  if (state.wifi_connected) {
    if (state.gps_error && !error_reported) {
      send_data_to_server(&state, var_burrito_host + var_burrito_post);
      error_reported = true;
    }
    if (has_gps_data) {
      send_data_to_server(&state, var_burrito_host + var_burrito_post);
    }
  }

  if (LOOP_DELAY > 0) {
    delay(LOOP_DELAY);
  }
}
