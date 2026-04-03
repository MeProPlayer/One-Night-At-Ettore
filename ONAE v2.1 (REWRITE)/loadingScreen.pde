byte MAX_LOADED_LEVEL = 45,
     loaded_level = 0;

void loading_bar(byte level) {
    noFill();
    stroke(255);
    rect(width / 2, height / 1.7, width / 4, height / 20);

    fill(255);
    rectMode(CORNER);
    rect(
        width / 2 - width / 8,
        height / 1.7 - height / 40,  
        map(level, 0, MAX_LOADED_LEVEL, 0, width / 4),
        height / 20
    );

    rectMode(CENTER);
}

PImage load_image(String asset_path) {
    loaded_level++;

    return loadImage(asset_path);
}

SoundFile load_sound(String asset_path) {
    loaded_level++;

    return new SoundFile(this, asset_path);
}