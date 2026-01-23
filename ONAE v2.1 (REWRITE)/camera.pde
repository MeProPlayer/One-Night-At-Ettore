float cam_pan_ind, cam_pos;

enum cam {
  bedroom, livingroom, bath_hall, m_restroom, w_restroom, service_room,
  closet, left_hall, right_hall;
}
cam current_cam = cam.bedroom;

void cam_condition(int n_cam) {
  if (n_cam != previous_cam_index) {
    camera_swap.amp(volume);
    camera_swap.play();

    switch (n_cam) {
      case 0: current_cam = cam.bedroom; break;
      case 1: current_cam = cam.livingroom; break;
      case 2: current_cam = cam.left_hall; break;
      case 3: current_cam = cam.right_hall; break;
      case 4: current_cam = cam.bath_hall; break;
      case 5: current_cam = cam.m_restroom; break;
      case 6: current_cam = cam.w_restroom; break;
      case 7: current_cam = cam.service_room; break;
      case 8: current_cam = cam.closet; break;
    }

    previous_cam_index = n_cam;
    previous_cam = int(millis());
  }
}

void camera_overlay(PImage camera) {
  float min_pos = width * (766.0 / 1920.0),
        max_pos = width * (1155.0 / 1920.0);

  if (mousePressed && 
      mouseX >= min_pos &&  mouseX <= max_pos && 
      mouseY >= height / 7 - (40 * res_ratio) && mouseY <= height / 7 + (40 * res_ratio)) {
    
    cam_pan_ind = constrain(mouseX, min_pos, max_pos);
    cam_pos = map(cam_pan_ind, min_pos, max_pos, width / 2 + width / 5, width / 2 - width / 5);
  }
  
  image(camera, cam_pos, height/2, img_width, img_height);
  draw_ettore();

  if (edger_attack) {
    image(edger, width/2, height/2); 
  }

  //fade in effect
  float static_timer = millis() - previous_cam;
  if (static_timer < 1000) {
    camera_static_opacity = int(map(static_timer, 0, 1000, 255, 100));
  }
  else {
    camera_static_opacity = 100;
  }

  tint(255, camera_static_opacity);
  image(camera_static, width / 2, height / 2);
  
  //camera pan     
  stroke(255);
  strokeWeight(3);
  line(768, height / 7, 1152, height / 7);
  noFill();
  rect(cam_pan_ind, height / 7, 40 * res_ratio, 40 * res_ratio);
  
  noStroke();
}

void _camera() {
  float x_offset = 0.835; // numero magico per il doc (non ricordo da che divisione lo tirata fuori)

  textSize(60 * res_ratio);
  textAlign(RIGHT);
  
  // glitched sound effect
  if (edger_attack && !is_flasher_jumpscare && !edger_moan.isPlaying()) {
    edger_moan.play();
  }
  else {
    edger_moan.stop();
  }

  // bedroom
  switch (current_cam) {
    case bedroom:
      camera_overlay(cam_Bedroom);
      text("cam_bedroom", width * x_offset, height/9.75);
      break;
       
    case livingroom: 
      camera_overlay(cam_Livingroom);
      text("cam_living_room", width * x_offset, height/9.75);
      break;
       
    case left_hall:
      camera_overlay(cam_left_hall);
      text("cam_left_hall", width * x_offset, height/9.75);
      break;
    
    case bath_hall:
      camera_overlay(cam_Bath_hall);
      text("cam_bath_hall", width * x_offset, height/9.75);  
      break;

    case m_restroom:
      camera_overlay(cam_M_restroom);
      text("cam_m_restroom", width * x_offset, height/9.75);
      break;

    case w_restroom:
      camera_overlay(cam_W_restroom);
      text("cam_w_restroom", width * x_offset, height/9.75);
      break;

    case service_room:
      camera_overlay(cam_Serviceroom);
      text("cam_service_room", width * x_offset, height/9.75);
      break;

    case closet:
      camera_overlay(cam_Closet);
      text("cam_closet", width * x_offset, height/9.75);
      break;
    
    case right_hall:
      camera_overlay(cam_right_hall);
      text("cam_right_hall", width * x_offset, height/9.75);
      break;

    default: break;
  }
  noTint();
  textAlign(CENTER, CENTER);
  image(camera, width/2, height/2, img_width/1.5, img_height);
  
  /*rectMode(LEFT);
  fill(0, 255, 0, 50);

  rect(width/(1920/348.f), height/(1080/445.f), width/(1920/514.f), height/(1080/498.f)); //bedroom
  rect(width/(1920/310.f), height/(1080/499.f), width/(1920/548.f), height/(1080/833.f)); //living room0
  rect(width/(1920/309.f), height/(1080/837.f), width/(1920/399.f), height/(1080/1015.f)); //left hall
  rect(width/(1920/618.f), height/(1080/837.f), width/(1920/708.f), height/(1080/1015.f)); //right hall
  rect(width/(1920/551.f), height/(1080/718.f), width/(1920/707.f), height/(1080/834.f)); //closet
  rect(width/(1920/618.f), height/(1080/636.f), width/(1920/768.f), height/(1080/715.f)); //service room
  rect(width/(1920/552.f), height/(1080/499.f), width/(1920/614.f), height/(1080/714.f)); //bathroom hall
  rect(width/(1920/618.f), height/(1080/522.f), width/(1920/767.f), height/(1080/572.f)); //women's restroom
  rect(width/(1920/618.f), height/(1080/582.f), width/(1920/767.f), height/(1080/633.f)); //men's restroom*/

  rectMode(CENTER);
}
