// int hand_height, constrained_mouse_y;
// float plushie_posX, plushie_posY;

// void test(){
  
    // if (!quit_menu) { noCursor(); }
    // else            { cursor(); }
    
    // background(124);
    
    // constrained_mouse_y = constrain(mouseY, 215, height);
    
    // hand_height = constrain(constrained_mouse_y, 215, height) + height/(1080/250);
    // hand_height = constrain(hand_height, 539, 1349);
    
    // image(plushie_test, plushie_posX, plushie_posY, img_width/3, img_height/3);
    // //rect(plushie_posX, plushie_posY, 300, 300);
    
    // stroke(0);
    // if (mousePressed) {
    //   image(player_hand_clenched, mouseX, hand_height, img_width/5, img_height); 
      
    //   if (mouseX > plushie_posX - width / (1920 / 150) && mouseX < plushie_posX + width / (1920 / 150) &&
    //       mouseY > plushie_posY - width / (1080 / 150) && mouseY < plushie_posY + width / (1080 / 150)) {
           
    //     plushie_posX = mouseX; 
    //     plushie_posY = hand_height - height/(1920/400);
    //   }
    // }
    // else {
    //   image(player_hand, mouseX, hand_height, img_width/5, img_height);
    // }
    // rect(mouseX, hand_height, 300, 300);
    // fill(255);
    
    
// }
/*
class playerHand{
  float constrained_mouse_y, hand_height;

  void display() {
    // This block will hopefully work and after that we'll make it worse
    constrained_mouse_y = constrain(mouseY, 215, height);

    hand_height = constrain(constrained_mouse_y, 215, height) + height/(1080/250);
    hand_height = constrain(hand_height, 539, 1349);
    // ---------------------------------------------------------------------------

    if (mousePressed) { image(player_hand_clenched, mouseX, hand_height, img_width/5, img_height); }
    else              { image(player_hand, mouseX, hand_height, img_width/5, img_height); }
  }
}*/
