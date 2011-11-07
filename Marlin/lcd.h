#ifdef DEULIGNE_LCD

  #define LCD_UPDATE_INTERVAL 100
  #define STATUSTIMEOUT 15000

  #define JOY_RIGHT 0
  #define JOY_DOWN  1
  #define JOY_UP    2
  #define JOY_LEFT  3
  #define JOY_OK    4

  Deuligne lcd;

  void lcd_init();
  void lcd_status();
  void lcd_status(const char* message);

#endif
