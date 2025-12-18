
//WORK ON MOVEment and CHECK FOR GAME FUNCTION FOR FULLSCREEN SCALING AND FINISH flasher delay and maybe jumpscare idk FIX ALL AUDIO VOLUME
//make a sprite for the doors
/*

FIX GAME NOT DRAWING ANYTHING

TO DO
- ettore entity (jumpscare)
- ettorina entity
- edger bar and (camera stalker DONE)
- custom night (3 night challenges)
- maybe secret cutscene for 4/20 mode

FIX AUDIO VOLUME PLAYING OR IDK
FIX THE FPS LMAOOO
FIX SOME BUTTONS NOT WORKING

FIX FERRANDINO ATTACK*/
import processing.sound.*;
import gifAnimation.*;

Gif camera_static;
SoundFile menu_ost, door, office_ost, camera_swap, monitor_up_down, edger_moan, ETTORE_SCREAM;
String word, 
       cam_path = "cam/";
PImage ETTORE,
       menu_background, office, camera,
       left_door, right_door,
       flasher, Flasher_jumpscare, Flasher_jumpscare_rare,
       edger,
       
       cam_Bedroom, cam_Livingroom, cam_left_hall, cam_right_hall, cam_Bath_hall, 
       cam_W_restroom, cam_M_restroom, cam_Serviceroom, cam_Closet,
       
       ettore_bedroom, ettore_livingroom, ettore_left_hall, ettore_bath_hall, 
       ettore_w_restroom, ettore_m_restroom, ettore_service_room, ettore_closet,
       ettore_right_hall, ettore_left_door, ettore_right_door,
       ettore_at_left_door, ettore_at_right_door;
       
boolean ETTORE_ATTACK = false, 
        quit_menu = false,
        is_43 = false, on_hitbox = false,
        assets_loaded = false, is_camera = false, is_jumpscare = false, 
        is_camera_cooldown = false,
        
        edger_attack = false, ector_counter = false,
        flasher_attack = false, is_flasher_jumpscare = false,
        prev_cam = false,
        show_fps = false,
        left_door_on = false, right_door_on = false, is_door_cooldown = false,
        ask_menu = false;
        
float res_ratio, img_width, img_height, 
      timer, flasher_timer = 0, door_cooldown = 0, door_cooldown_start = 0, 
      volume = 1 /*1 default, max 2 min 0*/,
      black_bar_offset, office_posx, office_posy,
      volume_pos, camera_static_opacity;
      
int constnt = 1000, previous_cam = 0,
    frame_rate = 120, chosen_framerate = 0, framerate[] = {60, 75, 90, 120},
    previous_cam_index = 0;

enum state{
  menu, info, settings, game;
}
state current_state = state.menu;

void setup() {
  fullScreen(P2D);
  frameRate(frame_rate);
  
  background(0);
  
  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER, CENTER);

  textFont(createFont("font/Pixellari.ttf", 100));
  
  office_posx = width/2;
  office_posy = height/2;
  volume_pos = width * (((1135 + 796)/2)/1920.f);
  cam_pan_ind = width/2;
  cam_pos = cam_pan_ind;
  
  //load everything in a separate thread
  thread("load_assets");
}

void load_assets(){
  ETTORE = loadImage("ETTORE.png");
  ETTORE_SCREAM = new SoundFile(this, "ETTORE.wav");
  
  camera_static = new Gif(this, cam_path + "camera_static_test_final.gif");
  camera_static.play();
  
  menu_ost = new SoundFile(this, "menu_ost.wav");
  office_ost = new SoundFile(this, "office_audio.wav");
  door = new SoundFile(this, "door.wav");
  camera_swap = new SoundFile(this, cam_path +  "camera_change.wav");
  monitor_up_down = new SoundFile(this, cam_path +  "monitor_up.wav");
  edger_moan = new SoundFile(this, "moan.wav");
  
  flasher = loadImage("the_flasher.png");
  Flasher_jumpscare = loadImage("flasher_jumpscare.png");
  Flasher_jumpscare_rare = loadImage("flasher_jumpscare_rare.png");
  
  edger = loadImage("ector_cam.jpg");
  
  menu_background = loadImage("menu_background.png");
  office = loadImage("office_test.png");
  left_door = loadImage("left_door.png");
  right_door = loadImage("right_door.png");
  camera = loadImage(cam_path + "camera.png");
  
  ettore_at_left_door =  loadImage("ettore_left_door.png");
  ettore_at_right_door =  loadImage("ettore_right_door.png");
  
  cam_Bedroom = loadImage(cam_path + "cam_bedroom.png");
  cam_Livingroom = loadImage(cam_path + "cam_livingroom.png");
  cam_left_hall = loadImage(cam_path + "cam_left_hall.png");
  cam_right_hall = loadImage(cam_path + "cam_right_hall.png");
  cam_Bath_hall = loadImage(cam_path + "cam_bath_hall.png");
  cam_W_restroom = loadImage(cam_path + "cam_w_restroom.png");
  cam_M_restroom = loadImage(cam_path + "cam_m_restroom.png");
  cam_Serviceroom = loadImage(cam_path + "cam_service_room.png");
  cam_Closet = loadImage(cam_path + "cam_closet.png");

  ettore_bedroom = loadImage(cam_path + "cam_bedroom_ettore.png");
  ettore_livingroom = loadImage(cam_path + "cam_livingroom_ettore.png");
  ettore_bath_hall = loadImage(cam_path + "cam_bath_hall_ettore.png");
  ettore_w_restroom = loadImage(cam_path + "cam_w_restroom_ettore.png");
  ettore_m_restroom = loadImage(cam_path + "cam_m_restroom_ettore.png");
  ettore_service_room = loadImage(cam_path + "cam_service_room_ettore.png");
  ettore_closet = loadImage(cam_path + "cam_closet_ettore.png");
  ettore_left_hall = loadImage(cam_path + "cam_left_hall_ettore.png");
  ettore_right_hall = loadImage(cam_path + "cam_right_hall_ettore.png");
  ettore_left_door = loadImage(cam_path + "cam_left_hall_ettore_lDoor.png");
  ettore_right_door = loadImage(cam_path + "cam_right_hall_ettore_rDoor.png");
  
  assets_loaded = true;
  apply_resolution();
}

//very useful!
boolean mouse_check(float x0, float x1, float y0, float y1){
  if(mouseX > width/(1920/x0) && mouseX < width/(1920/x1) &&
      mouseY > height/(1080/y0) && mouseY < height/(1080/y1)){
     return true;
  }
  else{
    return false;
  }
}

void menu(){
  image(menu_background, width/2, height/2, width, height);
  textAlign(LEFT, CENTER);
  textSize(80 * res_ratio * 1.5);
  fill(255);
  text("ONE\nNIGHT\nAT\nETTORE", width/40, height/3);
  
  textSize(50 * res_ratio * 1.5);
  text("Play\nSettings\nInfo", width/40, height/((1.5 + 1.25)/2));
  
  textSize(40 * res_ratio * 1.5);
  textAlign(CENTER, CENTER);
  //text("Premi Invio", width/2, height - height/20);
}

void game_settings(){
  textSize(50 * res_ratio * 1.5);
  text("SETTINGS", width/2, height/10);
  
  //fps
  textSize(40 * res_ratio * 1.5);
  stroke(255);
  strokeWeight(3);
  if(!show_fps){
    noFill();
  }
  else{
    fill(255); 
  }
  rect(width/2 - width/12, height/4, 20 * res_ratio, 20 * res_ratio);
  text("Show FPS", width/2 + width/50, height/4);
  noFill();
  
  //volume
  float min_vol_pos = width * (796/1920.f), max_vol_pos = width * (1135/1920.f);
  text("Volume", width/2, height/2.25);
  line(min_vol_pos, height/2, max_vol_pos, height/2);
  rect(volume_pos, height/2, 20 * res_ratio, 20 * res_ratio);
  if(mousePressed && 
    mouseX >= min_vol_pos &&  mouseX <= max_vol_pos && 
    mouseY >= height/2 - (50 * res_ratio) && mouseY <= height/2 + (50 * res_ratio)){
    volume_pos = mouseX;
    volume = map(mouseX, min_vol_pos, max_vol_pos, 0, 2);
  }
  
  //framerate
  text("Framerate", width * .475, height * .6);
  text(framerate[chosen_framerate], width * .58, height * .6);
  frame_rate = framerate[chosen_framerate];
  
  noStroke();
  //println("mvp: " + min_vol_pos + " Mvp: " + max_vol_pos);
  //println(volume);
}

void info(){
  textAlign(CENTER, CENTER);
  textSize(40 * res_ratio * 1.5);
  text("Ettore ti slimerà quando\nraggiungerà il tuo ufficio\n\n" +
       "Ettorina vuole uscire dal closet\n\nIl flasher se ne va " +
       "quando alzi il monitor\n\nScrivi il nome di ettore quando esce il " +
       "flasher", width/2, height/2);
}

void draw(){
  
  if(!assets_loaded){
    background(0);
    fill(255);
    text("LOADING...", width/2, height/2);
    
    return;
  }
  
  println("INPUT CHECK\ngame status: " + current_state + "\tassets:" + assets_loaded);
  
  frameRate(frame_rate);
  rectMode(CENTER);
  background(0);  
  if(height/width == 0.5625){
    is_43 = false;
  }
  else if(height/width == 0.75) {
    is_43 = true;
  }

  if(!is_43) black_bar_offset = width/8;

  res_ratio = width/1920.f;
  //println("ratio: " + res_ratio);
  
  switch(current_state){
    case menu: menu(); break;
      
    case settings: game_settings(); break;
  
    case info: info(); break;
  
    case game:
      if(mouseX > black_bar_offset &&
        mouseX < width - black_bar_offset){
        on_hitbox = true;
      }
      else{
        on_hitbox = false;
      } 
      game(); 
      break;
      
    default: break;
  }
  
  if(current_state == state.info || current_state == state.settings){
    textSize(40 * res_ratio * 1.5);
    text("Back to Menu", width/2, height * .9);
  }
  stroke(225);
  strokeWeight(2);
  fill(0);

  //leave menu
  if(quit_menu){
    textSize(40 * res_ratio * 1.5);
    rect(width/2, height/2, width/4, height/4);
    fill(255);
    text("EXIT MENU", width/2, height/2.25);
    
    if(current_state == state.menu){
      text("LEAVE   STAY", width/2, height/1.875);
    }
    else{
      text("LEAVE   MENU", width/2, height/1.875);
    }
  }
  noStroke();
  
  fill(255);
  //text("hitbox " + on_hitbox + '\n' + "mouseX " + mouseX + "\nmouseY " + mouseY , 250, 500);
  if(show_fps){
    textSize(50 * res_ratio * 1.5);
    text(int(frameRate) + " FPS", height * .9, height * .8);
  }
  
  if(ETTORE_ATTACK) image(ETTORE, width/2, height/2, img_width/1.5, img_height);
}

void reset(){
  //master reset
  cam_pan_ind = width/2;
  
  ettore_room = room.bedroom;

  quit_menu = false;
  
  flasher_attack = false;
  edger_attack = false;
  is_jumpscare = false;
  is_flasher_jumpscare = false;
  is_camera = false;
  left_door_on = false;
  right_door_on = false;
  is_door_cooldown = false;
  is_camera_cooldown = false;

  ettore_chance = 21;
  flasher_chance = 21;
  flasher_timer = 0;
  flasher_jumpscare_timer = 0;
  flasher_cooldown = 0;
  edger_chance = 21;
  word = "";
  
  door_cooldown = 0;
  timer = 0;

  cam_condition(0);

  current_state = state.menu;
}
