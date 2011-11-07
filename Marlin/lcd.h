#ifdef DEULIGNE_LCD

  #define LCD_UPDATE_INTERVAL 100
  #define STATUSTIMEOUT 15000

  Deuligne lcd;

  void lcd_init();
  void lcd_status();
  void lcd_status(const char* message);

#endif
