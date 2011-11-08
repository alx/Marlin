#ifdef DEULIGNE_LCD

char messagetext[LCD_WIDTH]="";
unsigned long previous_millis_lcd=0;

int previous_screen = -1;
int current_screen = SCREEN_HOME;

int key = -1;
int oldkey = -1;

int index_files = 0;

boolean lcd_refresh = false;

char calibration_labels[5][12] = {
  "Prepare   ",
  "Auto Home ",
  "Set Origin",
  "Preheat   ",
  "Extrude   " };
int calibration_step = CALIBRATION_PREPARE;

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
  int nb_files = getnrfilenames();
  if(((millis() - previous_millis_lcd) < LCD_UPDATE_INTERVAL)   )
    return;

  key = lcd.get_key();
  if (key != oldkey)   // if keypress is detected
  {
    oldkey = key;

    switch(current_screen){
    case SCREEN_HOME: // Main Menu
      switch(key){
        case JOY_LEFT:
          current_screen = SCREEN_CALIBRATE;
          break;
        case JOY_RIGHT:
        case JOY_OK:
        // goto select file
        current_screen = SCREEN_FILE;
        break;
      }
      break;
    case SCREEN_FILE: // Select file
      switch(key){
        case JOY_UP:
          index_files = index_files + 1;
          if(index_files >= nb_files){
            index_files = nb_files - 1;
          }
          lcd_refresh = true;
          break;
        case JOY_DOWN:
          index_files = index_files - 1;
          if(index_files < 0){
            index_files = 0;
          }
          lcd_refresh = true;
          break;
        case JOY_LEFT:
          // return to main menu
          current_screen = SCREEN_HOME;
          break;
        case JOY_RIGHT:
        case JOY_OK:
          char cmd[30];
          sprintf(cmd,"M23 %s",filename);
          for(int i=0;i<strlen(filename);i++)
            filename[i]=tolower(filename[i]);
          enquecommand(cmd);
          enquecommand("M24");
          // load printing
          current_screen = SCREEN_PRINT;
          break;
      }
      break;
    case SCREEN_PRINT: // Print screen
      switch(key){
        case JOY_LEFT:
        // return to file menu
        current_screen = SCREEN_FILE;
        break;
      }
      break;
    case SCREEN_CALIBRATE: // Calibrate screen
      switch(key){
        case JOY_LEFT:
        // return to main menu
        current_screen = SCREEN_HOME;
        break;
        case JOY_OK:
        calibration_step += 1;
        switch (calibration_step){
          case CALIBRATION_HOME:
            enquecommand("G28 X-105 Y-105 Z0");
            break;
          case CALIBRATION_ORIGIN:
            enquecommand("G92 X0 Y0 Z0");
            break;
          case CALIBRATION_PREHEAT:
            target_raw = temp2analog(170);
            break;
          case CALIBRATION_EXTRUDE:
            enquecommand("G92 E0");
            enquecommand("G1 F700 E50");
            break;
          case CALIBRATION_DISABLE_STEPPERS:
            enquecommand("M84");
            calibration_step = CALIBRATION_PREPARE;
            current_screen=SCREEN_HOME;
            break;
        }
        lcd_refresh = true;
        break;
      }
      break;
    }

  }

  previous_millis_lcd=millis();
  if(lcd_refresh || previous_screen != current_screen){
    previous_screen = current_screen;
    lcd_refresh = false;

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
      lcd.print("Select file - " + nb_files);
      lcd.setCursor(0, 1);
      getfilename(index_files);
      lcd.print("> " + String(filename));
      break;
    case SCREEN_PRINT:    // Printing
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("Printing...");
      break;
    case SCREEN_CALIBRATE: // Calibration
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("Calibration");
      lcd.setCursor(0, 1);
      lcd.print(calibration_labels[calibration_step]);
      break;
    } 

  }
}

void getfilename(const uint8_t nr)
{
#ifdef SDSUPPORT  
  dir_t p;
  root.rewind();
  uint8_t cnt=0;
  filename[0]='\0';
  while (root.readDir(p) > 0)
  {
    if (p.name[0] == DIR_NAME_FREE) break;
    if (p.name[0] == DIR_NAME_DELETED || p.name[0] == '.'|| p.name[0] == '_') continue;
    if (!DIR_IS_FILE_OR_SUBDIR(&p)) continue;
    if(p.name[8]!='G') continue;
    if(p.name[9]=='~') continue;
    if(cnt++!=nr) continue;
    Serial.println((char*)p.name);
    uint8_t writepos=0;
    for (uint8_t i = 0; i < 11; i++) 
    {
      if (p.name[i] == ' ') continue;
      if (i == 8) {
        filename[writepos++]='.';
      }
      filename[writepos++]=p.name[i];
    }
    filename[writepos++]=0;
  }
#endif  
}

uint8_t getnrfilenames()
{
#ifdef SDSUPPORT
  dir_t p;
  root.rewind();
  uint8_t cnt=0;
  while (root.readDir(p) > 0)
  {
    if (p.name[0] == DIR_NAME_FREE) break;
    if (p.name[0] == DIR_NAME_DELETED || p.name[0] == '.'|| p.name[0] == '_') continue;
    if (!DIR_IS_FILE_OR_SUBDIR(&p)) continue;
    if(p.name[8]!='G') continue;
    if(p.name[9]=='~') continue;
    cnt++;
  }
  return cnt;
#endif
}


  #define LCD_MESSAGE(x) lcd_status(x);
  #define LCD_STATUS lcd_status()

#endif
