int hand_height;
float plushie_posX, plushie_posY;

void test(){
    if(!quit_menu) noCursor();
    else           cursor();
    background(124);
    fill(255);
    text(mouseY, 100, 100);
    hand_height = mouseY + height/(1080/250);
    
    image(plushie_test, plushie_posX, plushie_posY, img_width/3, img_height/3);
    //rect(plushie_posX, plushie_posY, 300, 300);
    
    stroke(0);
    if(mousePressed){
      image(player_hand_clenched, mouseX, hand_height, img_width/5, img_height); 
      
      if(mouseX > plushie_posX - width/(1920/150) && mouseX < plushie_posX + width/(1920/150) &&
         mouseY > plushie_posY - width/(1080/150) && mouseY < plushie_posY + width/(1080/150)){
           
        plushie_posX = mouseX; 
        plushie_posY = mouseY + height/(1920/100);
      }
    }
    else{
      image(player_hand, mouseX, hand_height, img_width/5, img_height);
    }
    //rect(mouseX, hand_height, 300, 300);
     
}
