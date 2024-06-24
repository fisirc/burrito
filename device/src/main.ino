#include <DHT.h>
#include <TinyGPS++.h>
#include <LiquidCrystal_I2C.h>

#define LED_PORT 2

/* 20x4 LED Configuration */
#define I2C_ADDR    0x27
#define LCD_COLUMNS 20
#define LCD_LINES   4
LiquidCrystal_I2C lcd(I2C_ADDR, LCD_COLUMNS, LCD_LINES);

/* DHT22 Configuration */
#define DHT22_PORT 5
DHT dht22(DHT22_PORT, DHT22);

/* neo6m GPS Configuration */
#define RXD2 16
#define TXD2 17
#define GPS_SERIAL Serial2
#define DEBUG_GPS_NMEA false
TinyGPSPlus gps;

/* 🚌 Burrito setup code */

void setup() {
  pinMode(LED_PORT, OUTPUT);
  Serial.begin(115200);
  GPS_SERIAL.begin(9600, SERIAL_8N1, RXD2, TXD2);

  dht22.begin();
  lcd_setup();

  Serial.print("Burrito tracker started\n");
}

/* 🚌 Burrito loop code */

#define INVALID_WEATHER  -273.0f
#define INVALID_HUMIDITY -1.0f
float temp, humidity;

#define INVALID_COORD -1.0f
#define LOADING_COORD -2.0f
float lat = LOADING_COORD, lng = LOADING_COORD;

// Pre declarations
void display_weather(float temp = INVALID_WEATHER, float humidity = INVALID_HUMIDITY, int row = 3);
void display_burrito_pos(float lat = INVALID_COORD, float lng = INVALID_COORD, int row = 1);

void loop() {
  bool gps_ready = gps_delay(1000);

  temp = dht22.readTemperature();
  humidity = dht22.readHumidity();

  if (gps_ready && gps.location.isValid()) {
    lat = gps.location.lat();
    lng = gps.location.lng();
  }
  else if (lat != LOADING_COORD) {
    lat = INVALID_COORD;
    lng = INVALID_COORD;
  }

  if (isnan(temp)) {
    temp = INVALID_WEATHER;
  }
  if (isnan(humidity)) {
    humidity = INVALID_HUMIDITY;
  }

  display_burrito_pos(lat, lng);
  display_weather(temp, humidity);
  delay(500);
}

// Try to read from the GPS serial for 'ms' milliseconds.
// If the satellite payload is complete, gps.encode returns true and
// so the function. gps.location.isValid should be true in this scenario.
// Returns false on timeout.
bool gps_delay(unsigned long ms) {
  unsigned long start = millis();
  do  {
    while (GPS_SERIAL.available() > 0) {
      // This debugging branch prints the NMEA in the programming serial
      if (DEBUG_GPS_NMEA) {
        byte read = GPS_SERIAL.read();
        Serial.print((char)read);
        if (gps.encode(read)) {
          display_burrito_pos(gps.location.lat(), gps.location.lng());
        }
        continue;
      }

      if (gps.encode(GPS_SERIAL.read())) {
        return true;
      }
    }
  } while (DEBUG_GPS_NMEA || millis() - start < ms);
  return false;
}

/* Display related functions and custom char definitions */
#define CHAR_BURRITO1 "\x01"
#define CHAR_BURRITO2 "\x02"
#define CHAR_TEMP     "\x03"
#define CHAR_RAINDROP "\x04"

uint8_t custom_char_burrito1[8] = {
  0b00000,
  0b00000,
  0b11111,
  0b10101,
  0b11111,
  0b11111,
  0b01000,
  0b00000,
};
uint8_t custom_char_burrito2[8] = {
  0b00000,
  0b00000,
  0b11111,
  0b10100,
  0b11111,
  0b11111,
  0b00010,
  0b00000,
};
uint8_t custom_char_temperature[8] = {
  0b00100,
  0b01010,
  0b01010,
  0b01010,
  0b01010,
  0b10001,
  0b10001,
  0b01110,
};
uint8_t custom_char_raindrop[8] = {
  0b00100,
  0b01110,
  0b01110,
  0b11111,
  0b11111,
  0b11111,
  0b11111,
  0b01110,
};

void lcd_setup() {
  lcd.init();
  lcd.backlight();
  lcd.createChar(0x01, custom_char_burrito1);
  lcd.createChar(0x02, custom_char_burrito2);
  lcd.createChar(0x03, custom_char_temperature);
  lcd.createChar(0x04, custom_char_raindrop);
}

void display_burrito_pos(float lat, float lng, int row) {
  String s_lat = String(lat, 3);
  String s_lng = String(lng, 3);
  lcd.setCursor(0, row);
  lcd.print(CHAR_BURRITO1 CHAR_BURRITO2 " ");

  if (lat == INVALID_COORD || lng == INVALID_COORD) {
    lcd.print("error!           ");
  }
  else if (lat == LOADING_COORD || lng == LOADING_COORD) {
    lcd.print("loading...       ");
  }
  else {
    lcd.print("(");
    lcd.print(s_lat);
    lcd.print(",");
    lcd.print(s_lng);
    lcd.print(")");
  }
}

void display_weather(float temp, float humidity, int row) {
  lcd.setCursor(0, row);
  lcd.print(CHAR_TEMP" ");

  if (temp == INVALID_WEATHER) {
    lcd.print(" -- ");
  }
  else {
    lcd.print(temp);
    lcd.print("C ");
  }

  lcd.setCursor(9, row);
  lcd.print("  "CHAR_RAINDROP" ");
  if (humidity == INVALID_HUMIDITY) {
    lcd.print(" -- ");
  }
  else {
    lcd.print(humidity);
    lcd.print("% ");
  }
}
