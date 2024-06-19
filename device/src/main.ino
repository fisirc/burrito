#include <Wire.h>
#include <DHT.h>
#include <TinyGPS++.h>
#include <LiquidCrystal_I2C.h>

#define LED_PORT 2
#define DHT22_PORT 5

DHT dht22(DHT22_PORT, DHT22);

#define I2C_ADDR    0x27
#define LCD_COLUMNS 20
#define LCD_LINES   4

LiquidCrystal_I2C lcd(I2C_ADDR, LCD_COLUMNS, LCD_LINES);

#define RXD2 16
#define TXD2 17

#define GPS_SERIAL Serial2
TinyGPSPlus gps;

void setup() {
  pinMode(LED_PORT, OUTPUT);
  Serial.begin(9600);
  GPS_SERIAL.begin(9600);
  dht22.begin();
  lcd.init();
  lcd.backlight();
  lcd.clear();
}

float temp, humidity;

void loop() {
  Serial.print("start loop\n");
  bool gps_ready = gps_delay(1000);

  temp = dht22.readTemperature();
  humidity = dht22.readHumidity();

  if (gps_ready && gps.location.isValid()) {
    String lat = String(gps.location.lat(), 6);
    String lon = String(gps.location.lng(), 6);
    lcd.setCursor(0, 1);
    lcd.print("Lat: ");
    lcd.print(lat);
    lcd.setCursor(0, 2);
    lcd.print("Long: ");
    lcd.print(lon);
  }

  lcd.setCursor(0, 0);
  lcd.print("Temperatura ");
  lcd.print(temp);
  lcd.print(" C ");
  delay(500);
}

// Returns true if new data is available
bool gps_delay(unsigned long ms) {
  unsigned long start = millis();
  do  {
    while (GPS_SERIAL.available() > 0) {
      if (gps.encode(GPS_SERIAL.read())) {
        return true;
      }
    }
  } while (millis() - start < ms);
  return false;
}
