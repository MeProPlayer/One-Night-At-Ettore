void tutorial() { // brutto da vedere ma va bene così la duplicazione dei codici è mandatorio
  float cam_scale = 1.25;
  if (on_hitbox) {
    office_posx = lerp(width - black_bar_offset * cam_scale/2, black_bar_offset * cam_scale/2, mouseX / (float)width);
  }
  office_posy = map(mouseY, 0, height, height/2 * cam_scale, height/2 / cam_scale); 

  image(office, office_posx, office_posy, img_width * cam_scale, img_height * cam_scale);

  if (left_door_on) {
    image(left_door, office_posx, office_posy, img_width * cam_scale, img_height * cam_scale);
  }
  if (right_door_on) {
    image(right_door, office_posx, office_posy, img_width * cam_scale, img_height * cam_scale);
  }

  if (is_camera) {
    _camera();
  }
  else {
    text("A toggle\ndella porta", office_posx - width / 1.925, office_posy);
    text("D toggle\ndella porta", office_posx + width / 1.925, office_posy);
  }
  text("S toggle camera", width / 2, height * .9);

  if (door_cooldown >= 1) {
    door_cooldown = 0;
    is_door_cooldown = false;
  }
  if (is_door_cooldown && door_cooldown < 1) {
    door_cooldown = millis() / 2000.f;
  }

  fill(0);
  stroke(255);
  rect(width / 2, height / 12.5, width / 8, height / 15);

  fill(255);
  text("Go Back", width / 2, height / 12.5);
  noStroke();

  draw_black_bars();
}