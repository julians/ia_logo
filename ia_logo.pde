PGraphics dingens;
PGraphics l;
PImage bild;
PImage logo;
PImage hintergrund;
color[] punkte;
int x = 0;
int y = 0;
int space = 10;

int argb = 0;
int argba[] = new int[4];
int rotation = 0;

QVector2D pb = new QVector2D(0, 0);

Integer[][] positions;

String[] testImages = {"sample.jpg", "sample2.jpg", "sample3.png", "sample4.jpg"};
int testImage = 1;
boolean changed = false;

void setup ()
{
    size(940, 673, P2D);
    l = createGraphics(720, 19, P2D);
    logo = loadImage("fhp.png");
    hintergrund = loadImage("bg.png");
    image(hintergrund, 0, 0);
    prep();
    smooth();
}

void prep ()
{
    dingens = createGraphics(236, 157, P2D);
    dingens.beginDraw();
        dingens.background(255);
        bild = loadImage(testImages[testImage]);
        dingens.image(bild, 0, 0);
        dingens.loadPixels();
        
        int blah = (l.width/space+1)*(l.height/space+3);
        positions = new Integer[blah][3];
        blah = dingens.pixels.length / blah;

        x = 0;
        y = -10;
        for (int i = 0; i < positions.length; i++) {
            positions[i][0] = new Integer(x);
            positions[i][1] = new Integer(y);
            positions[i][2] = new Integer(dingens.pixels[i*blah]);
            x += space;
            if (x >= (l.width/space+1)*space) {
                x = 0;
                y += space;
            }
        }
    dingens.endDraw();
    
    fill(255);
    noStroke();
    rect(0, 0, width, 19);
    
    //Collections.shuffle(Arrays.asList(positions));
    
    loop();
}

void draw ()
{
    drawLogo();
    translate(32, 0);
    image(l, 0, 0, l.width, l.height);
    image(logo, 0, 4);
    resetMatrix();
    noLoop();
}

void keyPressed ()
{
    if (key == CODED) {
        switch (keyCode) {
            case RIGHT:
                changed = true;
                testImage++;
                break;
            case LEFT:
                changed = true;
                testImage--;
                break;
        }
    }
    if (changed == true) {
        if (testImage >= testImages.length) testImage = 0;
        if (testImage < 0) testImage = testImages.length-1;
        prep();
    }
}

void mouseMoved ()
{
    loop();
}

void drawLogo ()
{
    l.beginDraw();
    l.background(255);
    
    for (int i = 0; i < positions.length; i++) {
        x = positions[i][0];
        y = positions[i][1];
        argb = positions[i][2];
        argba[0] = (argb >> 24) & 0xFF;
        argba[1] = (argb >> 16) & 0xFF;
        argba[2] = (argb >> 8) & 0xFF;
        argba[3] = argb & 0xFF;
        
        rotation = 0;
        for (int j = 1; j < 4; j++) {
            rotation += argba[j];
        }
        rotation /= 3;
        
        l.translate(x, y);
        l.rotate(radians(rotation));
        
        l.fill(argba[1], argba[2], argba[3], noise(x, y, (float)frameCount/30)*100);
        l.stroke(argba[1], argba[2], argba[3], noise(x, y, (float)frameCount/30)*150);
        l.beginShape();
        for (int j = 0; j < 3; j++) {
            pb.set(0, 5*-1);
            pb.mult(map(argba[j+1], 0, 255, 1, 5));
            pb.rotate(120*j);
            l.vertex(pb.x, pb.y);
        }
        l.endShape(CLOSE);
        l.resetMatrix();
    }
    l.endDraw();
}