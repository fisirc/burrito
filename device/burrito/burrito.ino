#include <WiFi.h>
#include <HTTPClient.h>
#include "display.h"
#include "constants.h"
#include "location.h"

String var_wifi_ssid     = "the_hot_spot";
String var_wifi_password = "delunoalnueve";
String var_burrito_host  = "https://burrito-server.shuttleapp.rs";
String var_burrito_post  = "/give-position/";

LiquidCrystal_I2C lcd(I2C_ADDR, LCD_COLUMNS, LCD_LINES);
DHT dht22(DHT22_PORT, DHT22);
TinyGPSPlus gps;

struct app_state {
  float lat;
  float lng;
  float temp;
  float humidity;
  bool wifi_connected;
};

struct app_state state;

bool setup_wifi(LiquidCrystal_I2C* lcd = nullptr);
bool send_data_to_server(struct app_state payload);
bool wifi_is_connected();

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
  state.wifi_connected = setup_wifi(&lcd);
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
    send_data_to_server(&state);
  }
  delay(LOOP_DELAY);
}

bool wifi_is_connected() {
  return WiFi.status() == WL_CONNECTED;
}

// Sends the data to the burrito
bool send_data_to_server(const struct app_state* payload) {
  if (payload->lat == INVALID_COORD || payload->lat == LOADING_COORD) {
    return false;
  }

  HTTPClient http;
  http.begin(var_burrito_host + var_burrito_post);
  http.addHeader("content-type", "application/json");
  http.addHeader("accept", "*/*");
  http.addHeader("user-agent", "burrito-tracker");
  int code = http.POST(
    String("{\"latitud\":\"") + String(payload->lat, 6) +
    String("\",\"longitud\":\"") + String(payload->lng, 6) + "\"}"
  );
  if (code < 0) {
    Serial.printf("[HTTP] POST error: %s\n", http.errorToString(code).c_str());
    http.end();
    return false;
  }
  if (code != HTTP_CODE_OK) {
    Serial.printf("[HTTP] POST error: code %d\n", code);
    http.end();
    return false;
  }
  Serial.println("[HTTP] POST success!");
  http.end();
  return true;
}

bool setup_wifi(LiquidCrystal_I2C* lcd) {
  WiFi.begin(var_wifi_ssid, var_wifi_password);
  Serial.print("Connecting wifi");

  unsigned short step = 0;
  while (WiFi.status() != WL_CONNECTED) {
    if (lcd != nullptr) {
      display_booting_up(lcd, step);
    }
    delay(500);
    Serial.print(".");
    step++;
  }
  Serial.print("\nConnected to WiFi network with IP Address: ");
  Serial.println(WiFi.localIP());
  return true;
}
