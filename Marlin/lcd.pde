#ifdef DEULIGNE_LCD

char messagetext[LCD_WIDTH]="";
unsigned long previous_millis_lcd=0;

int previous_screen = -1;
int current_screen = SCREEN_HOME;

int key = -1;
int oldkey = -1;

void lcd_init()
{
  lcd.init();
  lcd_status();
}

void clear()
{
  lcd.clear();
}

void lcd_status(const char* message)
{
  strncpy(messagetext,message,LCD_WIDTH);
}

void lcd_status()
{
  if(((millis() - previous_millis_lcd) < LCD_UPDATE_INTERVAL)   )
    return;

  key = lcd.get_key();
  if (key != oldkey)   // if keypress is detected
  {
    oldkey = key;

    switch(current_screen){
    case SCREEN_HOME: // Main Menu
      switch(key){
        case JOY_OK:
        // goto select file
        current_screen = SCREEN_FILE;
        break;
      }
      break;
    case SCREEN_FILE: // Select file
      switch(key){
        case JOY_LEFT:
        // return to main menu
        current_screen = SCREEN_HOME;
        break;
        case JOY_OK:
        // load printing
        current_screen = SCREEN_PRINT;
        break;
      }
      break;
    }

  }

  previous_millis_lcd=millis();
  if(previous_menu != current_menu){
    previous_menu = current_menu;

    switch (current_screen) {
    case SCREEN_INIT:    // Initializing
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("Marlin");
      lcd.setCursor(7, 0);
      lcd.print(version_string);
      lcd.setCursor(0, 1);
      lcd.print("initializing...");
      current_screen = SCREEN_HOME;
      break;
    case SCREEN_HOME:    // Main Menu
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("Marlin");
      lcd.setCursor(0, 1);
      lcd.print("> Select file");
      break;
    case SCREEN_FILE:    // Select file
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("Select file");
      lcd.setCursor(0, 1);
      lcd.print("> file1");
      break;
    case SCREEN_PRINT:    // Printing
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("Printing...");
      break;
    } 

  }
}

  #define LCD_MESSAGE(x) lcd_status(x);
  #define LCD_STATUS lcd_status()

#endif
