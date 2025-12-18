// FIX ALL AIII
PImage office_scaled, ettore_left_scaled, ettore_right_scaled;
float ai_update_time = 0,
      ettore_timer = 0, ettore_cooldown = 0, ettore_jumpscare_timer = 0,
      flasher_cooldown = 0, flasher_jumpscare_timer = 0,
        scale;
int ettore_chance = 21, ettore_ai,
    flasher_chance = 21, flasher_ai,
    edger_chance = 21, edger_ai;

void scale_sprites(){
  office_scaled = office.copy();
  office_scaled.resize(int(img_width), int(img_height));

  ettore_left_scaled = ettore_at_left_door.copy();
  ettore_left_scaled.resize(int(img_width), int(img_height));

  ettore_right_scaled = ettore_at_right_door.copy();
  ettore_right_scaled.resize(int(img_width), int(img_height));
}

void recall_scale(){
  float screen_aspect = float(width)/height,
        img_aspect = 4/3.f;

  if (screen_aspect > img_aspect) {
    scale = float(height)/office.height;
  } 
  else {
    scale = float(width)/office.width;
  }

  img_width = office.width * scale;
  img_height = office.height * scale;
}

void apply_resolution(){
    recall_scale();
    scale_sprites();
}

void game(){ 
  int now = millis();

  if(timer == 6){
    current_state = state.menu;
    reset();
  }
  timer = now / 60000.f;

  update_ai();

  //ettore movement
  if(now - ettore_cooldown > ettore_timer){ 
    ettore_chance = (int)(Math.random() * 21);

    if (ettore_chance <= ettore_ai) {
      movement((byte)(Math.random() * 2)); 
    }
    ettore_cooldown = now;
  }

  //office position
  float cam_scale = 1.25;
  if(on_hitbox){
    office_posx = lerp(width - black_bar_offset * cam_scale/2, black_bar_offset * cam_scale/2, mouseX / float(width));
  }
  office_posy = map(mouseY, 0, height, height/2 * cam_scale, height/2 / cam_scale); 

  image(office, office_posx, office_posy, img_width*cam_scale, img_height*cam_scale);

  //draw ettore at the doors
  switch(ettore_room){
    case left_door:
      image(ettore_at_left_door, office_posx, office_posy, img_width * cam_scale, img_height * cam_scale);
      break;

    case right_door:
      image(ettore_at_right_door, office_posx, office_posy, img_width * cam_scale, img_height * cam_scale);
      break;
    default: break;
  }
  
  if(left_door_on || right_door_on) ettore_room = room.bedroom;
  
  //draw doors
  if(left_door_on){
    image(left_door, office_posx, office_posy, img_width*cam_scale, img_height*cam_scale);
  }
  if(right_door_on){
    image(right_door, office_posx, office_posy, img_width*cam_scale, img_height*cam_scale);
  }

  draw_flasher();

  if(is_camera) {
    if(flasher_attack || is_flasher_jumpscare){
      flasher_attack = false;
      is_flasher_jumpscare = false;
      flasher_timer = 0;
      flasher_jumpscare_timer = 0;
    }

    _camera();
  }

  fill(255);
  if(timer < 1){
    text("12 AM", width/12.5 + black_bar_offset, height/15);
  }
  else{
    text(int(timer) + " AM", width/12.5 + black_bar_offset, height/15);
  }

  fill(0);
  rect(black_bar_offset/2, height/2, black_bar_offset, height);
  rect(width - black_bar_offset/2, height/2, black_bar_offset, height);

  fill(250);
  text("Current: " + ettore_room, width - width / 10, height / 2);

  if(door_cooldown >= 1){
    door_cooldown = 0;
    is_door_cooldown = false;
  }
  if(is_door_cooldown && door_cooldown < 1){
    door_cooldown = now / 2000.f;
  }

  text("ettore_ai: " + str(ettore_ai) + "\nflasher_ai: " + str(flasher_ai) + "\nedger_ai: " + str(edger_ai),
       width/(19.2/2), height/10.8);
}

void update_ai(){
  if (millis() - ai_update_time > 1000) {
    ai_update_time = millis();
    
    timer = millis() / 60000.0;
    ettore_ai = constrain(int(pow(timer * 1.4, 2)) + 1, 1, 20);

    flasher_ai = int(timer);
    edger_ai = int(timer + 1);
    ettore_timer = map(timer, 0, 6, 3000, 1200);
  }
}

void draw_flasher(){
  if (!flasher_attack && random(0, 21) <= flasher_ai){
    flasher_attack = true;
    flasher_timer = millis();
  }

  if(flasher_attack){
    if(millis() - flasher_timer < 2000){
      image(flasher, office_posx, office_posy, img_width*scale, img_height*scale);
    }
    else{
      is_flasher_jumpscare = true;
      flasher_attack = false;
      flasher_jumpscare_timer = millis();
    }
  }

  if(is_flasher_jumpscare){
    image(Flasher_jumpscare, width/2, height/2, img_width, img_height);

    if(random(0, 2) < 1){
      image(Flasher_jumpscare_rare, width/2, height/2, img_width, img_height);
    }
    if(millis() - flasher_jumpscare_timer > 2000){
      reset();
    }
  }
}
