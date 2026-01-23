enum room {
  bedroom, livingroom, bath_hall, m_restroom, w_restroom, service_room,
  closet, left_hall, right_hall, left_door, right_door;
}
room ettore_room = room.bedroom;

void movement(byte chance) {
  switch (ettore_room) {
    case bedroom: 
      ettore_room = room.livingroom; 
      break;

    case livingroom: 
      if (chance == 0) { ettore_room = room.left_hall; }
      else             { ettore_room = room.bath_hall; }
      break;

    case left_hall: 
      ettore_room = room.left_door; 
      break;

    case bath_hall:
      if (chance == 0) { ettore_room = room.m_restroom; }
      else             { ettore_room = room.w_restroom; }
      break;

    case m_restroom:
    case w_restroom:
      if (chance == 0) { ettore_room = room.service_room; }
      else             { ettore_room = room.closet; }
      break;

    case service_room:
      ettore_room = room.closet;
      break;

    case closet:
      ettore_room = room.right_hall;
      break;

    case right_hall:
      ettore_room = room.right_door;
      break;
    default: break;
  } 
}

void draw_ettore() {
  switch (ettore_room) {
    case bedroom:
      if (current_cam == cam.bedroom) {
        image(ettore_bedroom, cam_pos, height/2, img_width, img_height);
      }
      break;

    case livingroom: 
      if (current_cam == cam.livingroom) {
        image(ettore_livingroom, cam_pos, height/2, img_width, img_height);
      }
      break;

    case left_hall: 
      if (current_cam == cam.left_hall) {
        image(ettore_left_hall, cam_pos, height/2, img_width, img_height);
      }
      break;

    case left_door:
      if (current_cam == cam.left_hall) {  
        image(ettore_left_door, cam_pos, height/2, img_width, img_height);
      }
      break;

    case bath_hall:
      if (current_cam == cam.bath_hall) {
        image(ettore_bath_hall, cam_pos, height/2, img_width, img_height);
      }
      break;

    case m_restroom:
      if (current_cam == cam.m_restroom) {
        image(ettore_m_restroom, cam_pos, height/2, img_width, img_height);
      }
      break;

    case w_restroom:
      if (current_cam == cam.w_restroom) {
        image(ettore_w_restroom, cam_pos, height/2, img_width, img_height);
      }
      break;

    case service_room:
      if (current_cam == cam.service_room) {
        image(ettore_service_room, cam_pos, height/2, img_width, img_height);
      }
      break;

    case closet:
      if (current_cam == cam.closet) {
        image(ettore_closet, cam_pos, height/2, img_width, img_height);
      }
      break;

    case right_hall:
      if (current_cam == cam.right_hall) {
        image(ettore_right_hall, cam_pos, height/2, img_width, img_height);
      }
      break;

    case right_door:
      if (current_cam == cam.right_hall) {
        image(ettore_right_door, cam_pos, height/2, img_width, img_height);
      }
      break;

    default: break;
  }
}

void ettore_jumpscare() {
  if (!is_ettore_jumpscare) {
    ettore_jumpscare_timer= millis();
    is_ettore_jumpscare = true;
  }

  image(ettore_jumpscare, width / 2, height / 2, img_width, img_height);

  if (millis() - ettore_jumpscare_timer > 5000) { reset(); }
}