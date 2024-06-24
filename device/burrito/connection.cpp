#include <WiFi.h>
#include <HTTPClient.h>
#include "display.h"
#include "connection.h"

bool wifi_is_connected() {
  return WiFi.status() == WL_CONNECTED;
}

// Sends the data to the burrito
bool send_data_to_server(const struct app_state* payload, String endpoint) {
  if (payload->lat == INVALID_COORD || payload->lat == LOADING_COORD) {
    return false;
  }

  HTTPClient http;
  http.begin(endpoint);
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
