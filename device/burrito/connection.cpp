#include <WiFi.h>
#include <HTTPClient.h>
#include "display.h"
#include "connection.h"

bool wifi_is_connected() {
  return WiFi.status() == WL_CONNECTED;
}

// Sends the data to the burrito
bool send_data_to_server(const struct app_state* state, String endpoint) {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("[HTTP] WiFi not connected");
    return false;
  }

  HTTPClient http;
  http.begin(endpoint);
  http.setTimeout(6969);
  http.setConnectTimeout(6969);
  http.setReuse(false);
  http.setUserAgent("burrito-001");
  http.addHeader("content-type", "application/json");
  http.addHeader("connection", "close");

  int status = 0;

  if (state->gps_error) {
    status = 4;
  }

  String payload = String("{\"lt\":") +
    String(state->lat, 6) +
    String(",\"lg\":") + String(state->lng, 6) +
    String(",\"tmp\":") + String(state->temp, 2) +
    String(",\"hum\":") + String(state->humidity, 2) +
    String(",\"sts\":") + String(status) +
    "}";

  Serial.print("\n[HTTP] POST payload: ");
  Serial.println(payload);

  int code = http.POST(payload);

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

bool setup_wifi(LiquidCrystal_I2C* lcd, String ssid, String passwd) {
  WiFi.begin(ssid, passwd);
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
