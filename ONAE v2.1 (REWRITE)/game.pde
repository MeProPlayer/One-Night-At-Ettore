// folk folk folk sahur
boolean ettore_attack = false;
PImage office_scaled, ettore_left_scaled, ettore_right_scaled;
float ai_update_time = 0,
      ettore_timer = 0, ettore_cooldown = 0, ettore_attack_timer,
      ettore_max_attack_gap = 2000, ettore_jumpscare_timer,
      flasher_cooldown = 0, flasher_jumpscare_timer = 0,
      scale;
byte ettore_chance = 21,
     flasher_chance = 21,
     edger_chance = 21;
int ettore_ai, flasher_ai, edger_ai,
    night_start_timer = 0;

void scale_sprites() {
  office_scaled = office.copy();
  office_scaled.resize(int(img_width), int(img_height));

  ettore_left_scaled = ettore_at_left_door.copy();
  ettore_left_scaled.resize(int(img_width), int(img_height));

  ettore_right_scaled = ettore_at_right_door.copy();
  ettore_right_scaled.resize(int(img_width), int(img_height));
}

void recall_scale() {
  float screen_aspect = (float)width / height,
        img_aspect    = 4 / 3.f;

  if (screen_aspect > img_aspect) {
    scale = (float)height / office.height;
  } 
  else {
    scale = (float)width / office.width;
  }

  img_width  = office.width * scale;
  img_height = office.height * scale;
}

void apply_resolution() {
  recall_scale();
  scale_sprites();
}

void game() {
  timer = (millis() - night_start_timer) / (60000.f * 1.5);
  // println("TIMER: " + timer);

  if (timer >= 6) {
    celebrate();
  }

  update_ai();

  // ettore movement
  if (millis() - ettore_cooldown > ettore_timer) { 
    ettore_chance = (byte)(Math.random() * 21);

    if (ettore_chance <= ettore_ai) {
      movement((byte)(Math.random() * 2)); 
    }
    ettore_cooldown = millis();
  }
  
  // office position
  float cam_scale = 1.25;
  if (on_hitbox) {
    office_posx = lerp(width - black_bar_offset * cam_scale/2, black_bar_offset * cam_scale/2, mouseX / (float)width);
  }
  office_posy = map(mouseY, 0, height, height/2 * cam_scale, height/2 / cam_scale); 

  image(office, office_posx, office_posy, img_width * cam_scale, img_height * cam_scale);

  //draw ettore at the doors
  switch (ettore_room) { // augh codice duplicato augh!
    case left_door:

      if (!ettore_attack) { 
        ettore_attack_timer = millis(); 
        ettore_attack = true;
      }

      image(ettore_at_left_door, office_posx, office_posy, img_width * cam_scale, img_height * cam_scale);
      break;

    case right_door:

      if (!ettore_attack) { 
        ettore_attack_timer = millis(); 
        ettore_attack = true;
      }

      image(ettore_at_right_door, office_posx, office_posy, img_width * cam_scale, img_height * cam_scale);
      break;

    default: break;
  }

  if ((left_door_on && ettore_room == room.left_door) || 
      (right_door_on && ettore_room == room.right_door)) { 

    ettore_attack = false;
    ettore_room = room.bedroom; 
  }
  
  // draw doors
  if (left_door_on) {
    image(left_door, office_posx, office_posy, img_width * cam_scale, img_height * cam_scale);
  }
  if (right_door_on) {
    image(right_door, office_posx, office_posy, img_width * cam_scale, img_height * cam_scale);
  }

  draw_flasher();

  if (is_camera) {
    if (flasher_attack) {
      flasher_attack = false;
      flasher_jumpscare_timer = 0;
    }

    _camera();
  }
  else {
    edger_moan.stop();
  }

  fill(255);
  textSize(75 * res_ratio); // non è la soluzione migliore ma fair well

  if (timer < 1) {
    text("12 AM", width/12.5 + black_bar_offset, height/15);
  }
  else {
    text((int)timer + " AM", width/12.5 + black_bar_offset, height/15);
  }

  if ((ettore_room == room.right_door || 
       ettore_room == room.left_door) &&
      (millis() - ettore_attack_timer > ettore_max_attack_gap)) {

    ettore_jumpscare();
  }

  draw_black_bars();

  if (door_cooldown >= 1) {
    door_cooldown = 0;
    is_door_cooldown = false;
  }
  if (is_door_cooldown && door_cooldown < 1) {
    door_cooldown = millis() / 2000.f;
  }

  // debug();

}

void draw_black_bars() {
  fill(0);
  rect(black_bar_offset/2, height/2, black_bar_offset, height);
  rect(width - black_bar_offset/2, height/2, black_bar_offset, height);
}

void debug() {
  fill(250);
  textSize(35 * res_ratio);
  textAlign(LEFT, CENTER);

  text("ettore_ai: "    + str(ettore_ai) + 
       "\nflasher_ai: " + str(flasher_ai) + 
       "\nedger_ai: "   + str(edger_ai) + 
       "\n\n" + ettore_room,
       width / 200, height / 10);

  textAlign(CENTER, CENTER); // reset - soluzione temporanea
}

void update_ai() {
  if (millis() - ai_update_time > 2000) {
    ai_update_time = millis();

    ettore_ai = (byte)(timer / 6 * 20) + 1;
    ettore_max_attack_gap = 3500;

    // flasher_ai = int(timer);
    edger_ai = (byte)(timer / 3 + 1);

    flasher_ai = (byte)(timer / 2 + 1);

    ettore_timer = map(timer, 0, 6, 3000, 1200);
  }
}

void draw_flasher(){
  if (flasher_attack && !is_camera) {
    if (millis() - flasher_timer < 2000) {
      image(flasher, office_posx, office_posy, img_width * scale, img_height * scale);
    }
    else {
      is_flasher_jumpscare = true;
      flasher_attack = false;
      flasher_jumpscare_timer = millis();
    }
  }

  if (is_flasher_jumpscare) {
    if (!flasher_scream.isPlaying()) { flasher_scream.play(); }
    image(Flasher_jumpscare_rare, width/2, height/2, img_width, img_height);

    if(millis() - flasher_jumpscare_timer > 2000){
      reset();
    }
  }
}

void celebrate() {
  reset();
}