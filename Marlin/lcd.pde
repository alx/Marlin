#ifdef DEULIGNE_LCD

char messagetext[LCD_WIDTH]="";

void lcd_init()
{
  lcd.init();
  lcd.print("Marlin");
  lcd.setCursor(7, 0);
  lcd.print(version_string);
  lcd.setCursor(0, 1);
  lcd.print("initializing...");
}

void lcd_status(const char* message)
{
  strncpy(messagetext,message,LCD_WIDTH);
}

#endif
