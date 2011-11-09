#ifdef DEULIGNE_LCD

  #define LCD_UPDATE_INTERVAL 100
  #define STATUSTIMEOUT 15000

  #define JOY_RIGHT 0
  #define JOY_UP    1
  #define JOY_DOWN  2
  #define JOY_LEFT  3
  #define JOY_OK    4

  #define SCREEN_INIT      0
  #define SCREEN_HOME      1
  #define SCREEN_FILE      2
  #define SCREEN_PRINT     3
  #define SCREEN_CALIBRATE 4
  #define SCREEN_MANUAL    5

  #define CALIBRATION_PREPARE           0
  #define CALIBRATION_HOME              1
  #define CALIBRATION_ORIGIN            2
  #define CALIBRATION_PREHEAT           3
  #define CALIBRATION_EXTRUDE           4
  #define CALIBRATION_DISABLE_STEPPERS  5

  //Custom chars

  //Do not use, for char template only
  byte EMPTY_CHAR [8]={
  B00000,
  B00000,
  B00000,
  B00000,
  B00000,
  B00000,
  B00000
  };

  //Arrows custom chars

  #define CHAR_ARROW_UP 0
  byte ARROW_UP [8]={
  B00000,
  B00000,
  B00100,
  B01110,
  B11111,
  B00000,
  B00000
  };

  #define CHAR_ARROW_DOWN 1
  byte ARROW_DOWN [8]={
  B00000,
  B00000,
  B11111,
  B01110,
  B00100,
  B00000,
  B00000
  };

  #define CHAR_ARROW_RIGHT 2
  byte ARROW_RIGHT [8]={
  B00000,
  B01000,
  B01100,
  B01110,
  B01100,
  B01000,
  B00000
  };

  #define CHAR_ARROW_LEFT 3
  byte ARROW_LEFT [8]={
  B00000,
  B00010,
  B00110,
  B01110,
  B00110,
  B00010,
  B00000
  };

  Deuligne lcd;
  char filename[11];

  void lcd_init();
  void lcd_status();
  void lcd_status(const char* message);

  void key_interaction(const uint8_t key);
  void screen_display();

#endif
