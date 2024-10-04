import controlP5.*;

ControlP5 cp5;
Slider sizeSlider;
Slider NumberSlider;
int fishSize = 50;
// Button colourPicker;
int c = color(100);

String dataLink = "https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2024-08-19T22%3A13%3A47&rToDate=2024-08-23T22%3A13%3A47&rFamily=people_sh&rSensor=CB11.PC02.16.JonesStEast&rSubSensor=CB11.02.JonesSt+In";
Table data;
int fishNumber = 20; // can be customised to change the fish number
float[] startX, startY;
float[] size, speedX, speedY, direction;

void setup(){
    // Background and drawing setup
    size(800,800);
    cp5 = new ControlP5(this);

    sizeSlider = cp5.addSlider("fishSize")
            .setPosition(30,40)
            .setRange(30,50)
            .setHeight(20);
    smooth();

    sizeSlider = cp5.addSlider("fishNumber")
            .setPosition(30, 70)
            .setRange(1, 20)
            .setHeight(20);
    smooth();

    cp5.addColorWheel("c", 250, 10, 200).setRGB(color(128, 0, 255));
    noStroke();
    
    // Table setup
    data = loadTable(dataLink, "csv");

    // Declare array based on the number of fish number
    startX = new float[20];
    startY = new float[20];
    size = new float[20];
    speedX = new float[20];
    speedY = new float[20];
    direction = new float[20];

    // startX = new float[fishNumber];
    // startY = new float[fishNumber];
    // size = new float[fishNumber];
    // speedX = new float[fishNumber];
    // speedY = new float[fishNumber];
    // direction = new float[fishNumber];

    // Get Data
    for (int i = 0; i < fishNumber; i++) {
        // Get Data from the middle of the dataset
        for (int j = 100; j < data.getRowCount(); j++) {
            startX[i] = i; // set the value of x to the index
            startY[i] = data.getInt(j, 1); // set the value of y to the value of the people from the People Counter Dataset.
            // set the below to random to increase the variety of the fish
            // size[i] = random(30, 50);
            size[i] = fishSize;
            speedX[i] = random(-2, 2); 
            speedY[i] = random(-2, 2);
            // change the direction of the fish based on the speed
            direction[i] = atan2(speedY[i], speedX[i]);
        }
    }
}

void draw() {
    // Background Design
    // lightblue: background(173,216,230);
    // darkblue: background(56,132,207);
    background(246,215,176); // sand colour
    fill(56,132,207);
    noStroke();
    rect(0, 0, width, 7*height/8);

    // Reset the stroke
    stroke(255);
    strokeWeight(2);

    // Drawing fish according to fish number
    fish();
    // drawSlider();
}

void fish() {
    for (int i = 0; i < fishNumber; i++) {
        // move the fish to different direction with different speed
        startX[i] += speedX[i];  
        startY[i] += speedY[i];

        // Wrapping the fish by the border
        if (startX[i] > width) startX[i] = 0;
        if (startX[i] < 0) startX[i] = width;
        if (startY[i] > height) startY[i] = 0;
        if (startY[i] < 0) startY[i] = height;

        // push matrix to reset the position of each fish
        pushMatrix();
        // Use translate to set the origin point to draw the fish each time
        translate(startX[i], startY[i]);
        // use rotate to change the direction of the fish to where it's moving to
        rotate(direction[i]);

        // Get Data from the middle of the dataset
        size[i] = fishSize;
    

        // Fish Drawing
        fill(c);
        triangle(-size[i]/2, 0, -size[i], -20, -size[i], 20); // fish tail
        triangle(-size[i]/2, 0, size[i], 20, size[i], -20); // fish body
        triangle(3*size[i]/2, 0, size[i], 20,size[i], -20); // fish head
        // reset position
        popMatrix();
    }
}
