#ifdef DEULIGNE_LCD

char messagetext[LCD_WIDTH]="";
unsigned long previous_millis_lcd=0;

int previous_menu = -1;
int current_menu = 0;
// 0. Initializing
// 1. Main Menu
// 2. Select File
// 3. Printing

int key = -1;
int oldkey = -1;
// 0. right
// 1. up
// 2. down
// 3. left
// 4. ok

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

    switch(current_menu){
    case 1: // Main Menu
      switch(key){
        case JOY_OK:
        // goto select file
        current_menu = 2;
        break;
      }
      break;
    case 2: // Select file
      switch(key){
        case JOY_LEFT:
        // return to main menu
        current_menu = 1;
        break;
        case JOY_OK:
        // load printing
        current_menu = 3;
        break;
      }
      break;
    }

  }

  previous_millis_lcd=millis();
  if(previous_menu != current_menu){
    previous_menu = current_menu;

    switch (current_menu) {
    case 0:    // Initializing
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("Marlin");
      lcd.setCursor(7, 0);
      lcd.print(version_string);
      lcd.setCursor(0, 1);
      lcd.print("initializing...");
      current_menu = 1;
      break;
    case 1:    // Main Menu
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("Main Menu");
      lcd.setCursor(0, 1);
      lcd.print("> Select file");
      break;
    case 2:    // Select file
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("Select file");
      lcd.setCursor(0, 1);
      lcd.print("> file1");
      break;
    case 3:    // Printing
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
