String typedWord_secret;
char secret;

void mousePressed() {
  if (quit_menu) {
    //exit
    if (mouse_check(771, 940, 555, 597)) {
      exit();
    }
    //stop exit
    if (mouse_check(1003, 1153, 555, 597)) {
      quit_menu = false;
    }
    //back to the menu
    if (mouse_check(788, 1132, 951, 992) && 
      current_state != state.menu) {

      current_state = state.menu;
      reset();
    }

  }
  
  //play
  if (current_state == state.menu) {
    //game
    if (mouse_check(52, 180, 676, 730)) {
      night_start_timer = millis();
      current_state = state.game;
    }
    //settings
    if (mouse_check(52, 312, 759, 812)) {
      current_state = state.settings;
    }
    //info
    if (mouse_check(52, 175, 843, 896)) {
      current_state = state.info;
    }
  }
  //back to menu button
  else if (current_state != state.game &&
          mouse_check(788, 1131, 952, 992)) {

    current_state = state.menu;
  }
  //menu button from quit menu
  else if (mouse_check(1000, 1155, 557, 597)) {
    reset();
    current_state = state.menu;
  }

  camera_swap.amp(volume);
  if (current_state == state.game && is_camera) {
    //bedroom
    if (mouse_check(348, 514, 445, 498)) {
      cam_condition(0);
    } 
    //living room
    if (mouse_check(310, 548, 499, 833)) {
      cam_condition(1);
    }
    //left hall
    if (mouse_check(309, 399, 837, 1015)) {
      cam_condition(2);
    }
    //right hall
    if (mouse_check(618, 708, 837, 1015)) {
      cam_condition(3);
    }
    //bath hall
    if (mouse_check(552, 614, 499, 714)) {
      cam_condition(4);
    }
    //men's restroom
    if (mouse_check(618, 767, 582, 633)) {
      cam_condition(5);
    }
    //women's restroom
    if (mouse_check(618, 767, 522, 572)) {
      cam_condition(6);
    }
    //service room
    if (mouse_check(618, 768, 636, 715)) {
      cam_condition(7);
    }
    //closet
    if (mouse_check(551, 707, 718, 834)) {
      cam_condition(8);
    }
  }

  if (current_state == state.settings) {
    //settings
    if (mouseX < width/2 - width/12 + 10 * res_ratio && mouseX > width/2- width/12 - 10 * res_ratio &&
        mouseY < height/4 + 10 * res_ratio && mouseY > height/4 - 10 * res_ratio) {

      show_fps = !show_fps;   
    }
    //framerate
    if (mousePressed && mouseX >= width * .575 - 60 * res_ratio &&  mouseX <= width * .575 + 60 * res_ratio && 
      mouseY >= height * .605 - 40 * res_ratio && mouseY <= height * .605 + 40 * res_ratio) {
        
      chosen_framerate++;
      if (chosen_framerate > 3) {
        chosen_framerate = 0;
      }
    }
  }
}

void keyPressed() {
  
  //secret jumpscare
  secret = Character.toUpperCase(key);
  if (secret >= 'A' && secret <= 'Z') {
    typedWord_secret += secret;

    if (typedWord_secret.length() > 10) {
      typedWord_secret = typedWord_secret.substring(typedWord_secret.length() - 10);
    }

    if (typedWord_secret.endsWith("FERRANDINO") || typedWord_secret.endsWith("FERRANDA")) {
      if(!ETTORE_SCREAM.isPlaying()){
        image(ETTORE, width/2, height/2, img_width, img_height);
        ETTORE_SCREAM.play();
      }
      
      // delay(1000);
      exit();
    }
  }
  
  door.amp(volume);
  monitor_up_down.amp(volume);
  
  // if (key == 't' || key == 'T' && current_state == state.menu) { //test player hand
  //   current_state = state.test;
  // }
  
  if (key == ESC) {
    key = 0;  
    quit_menu = !quit_menu;
  }
  
  if (key == ENTER && current_state == state.menu) {
    night_start_timer = millis();
    current_state = state.game;
  }
  if ((key == 's' || key == 'S') && current_state == state.menu) {
    current_state = state.settings;
  }
  if ((key == 'i' || key == 'I') && current_state == state.menu) {
    current_state = state.info;
  }
  
  //reset to menu
  if (key == BACKSPACE && current_state != state.menu) {
    reset();
  }
  //game input
  if (current_state == state.game && !is_flasher_jumpscare) {
    //edger counter
    if (ector_counter && is_camera) {
      char c = Character.toUpperCase(key);
      
      if (c >= 'A' && c <= 'Z') {
        word += c;
        if (word.length() > 6) {
          word = word.substring(word.length() - 6);
        }
        if (word.equals("ETTORE")) {
          edger_attack = false;
          ector_counter = false;
          word = "";
        }
      }
    }   
    
    // camera toggle
    if (key == 's' || key == 'S') {
      if (!edger_attack) {
        edger_chance = (byte)(Math.random() * 21);

        if (edger_chance <= edger_ai) {
            edger_attack = true;
            ector_counter = true;
        }
      }

      if (!flasher_attack && !is_camera) {
      }

      monitor_up_down.amp(volume);
      monitor_up_down.play();
      is_camera = !is_camera;

      if (is_camera) {
        previous_cam = int(millis());
      }
      else {
        flasher_chance = (byte)(Math.random() * 21);

        if(flasher_chance <= flasher_ai) {
          flasher_timer = millis();
          flasher_attack = true;
        }
      }
    }

    // left door
    if ((key == 'a' || key == 'A') && 
        (!is_door_cooldown && millis() - door_cooldown_start >= 1000)) {

        door.amp(volume);
        door.play();
        right_door_on = false;
        left_door_on = !left_door_on;
        is_door_cooldown = true;
        door_cooldown_start = millis();
      }
    }
    //right door
    if((key == 'd' || key == 'D') &&
      (!is_door_cooldown && millis() - door_cooldown_start >= 1500)) {

      door.amp(volume);
      door.play();
      left_door_on = false;
      right_door_on = !right_door_on;
      is_door_cooldown = true;
      door_cooldown_start = millis();
    }

  // non riesco più a capire l'indentazione, non toccherò più questi if
}
