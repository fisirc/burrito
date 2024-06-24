#include "display.h"
#include "constants.h"
#include "location.h"
#include "connection.h"

String var_wifi_ssid     = "the_hot_spot";
String var_wifi_password = "delunoalnueve";
String var_burrito_host  = "https://burrito-server.shuttleapp.rs";
String var_burrito_post  = "/give-position/";

LiquidCrystal_I2C lcd(I2C_ADDR, LCD_COLUMNS, LCD_LINES);
DHT dht22(DHT22_PORT, DHT22);
TinyGPSPlus gps;

struct app_state state;

/* 🚌 Burrito setup code */

void setup() {
  state = {
    .lat = LOADING_COORD,
    .lng = LOADING_COORD,
    .temp = INVALID_TEMPERATURE,
    .humidity = INVALID_HUMIDITY,
    .wifi_connected = false,
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

void loop() {
  bool gps_ready = gps_delay(&gps, 1000);
  state.wifi_connected = wifi_is_connected();

  state.temp = dht22.readTemperature();
  state.humidity = dht22.readHumidity();

  if (gps_ready && gps.location.isValid()) {
    state.lat = gps.location.lat();
    state.lng = gps.location.lng();
  }
  else if (state.lat != LOADING_COORD) {
    state.lat = INVALID_COORD;
    state.lng = INVALID_COORD;
  }

  if (isnan(state.temp)) {
    state.temp = INVALID_TEMPERATURE;
  }
  if (isnan(state.humidity)) {
    state.humidity = INVALID_HUMIDITY;
  }

  display_header(&lcd);
  display_burrito_pos(&lcd, state.lat, state.lng);
  display_weather(&lcd, state.temp, state.humidity);
  if (state.wifi_connected) {
    send_data_to_server(&state, var_burrito_host + var_burrito_post);
  }
  delay(LOOP_DELAY);
}
