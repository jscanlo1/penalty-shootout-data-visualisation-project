PImage img; // Declare a variable of type PImage
Table table;

int W = 2400;
int H = 2000; 

float[] goal_zone_totals = {0,0,0,0,0,0,0,0,0};
float[] goal_zone_scored = {0,0,0,0,0,0,0,0,0};
float[] goal_zone_prob = {0,0,0,0,0,0,0,0,0};

int[] x_coord_zone = {W/3, W/2, 2*W/3,W/3, W/2, 2*W/3, W/3, W/2, 2*W/3};
int[] y_coord_zone = {4*H/27, 4*H/27, 4*H/27, 2*H/9, 2*H/9, 2*H/9, 8*H/27, 8*H/27, 8*H/27 };

int[] shot_direction = {0,0,0};
int right_foot_prob;
int left_foot_prob;

void setup() {
  
  
  
  size(2400,2000);
  // Make a new instance of a PImage by loading an image file
  img = loadImage("Football_small.png");
  table = loadTable("WorldCupShootouts.csv", "header");
  
  /*
  for (TableRow row : table.rows()) {

    int count = row.getInt("count");
    int x_coord = row.getInt("x_screen");
    int y_coord = row.getInt("y_screen");

    println("Count: "+ count + " X_coord:" + x_coord + " y_coord:  " + y_coord);
  }*/
  
  String foot;
  float right = 0;
  float right_total = 0;
  float left = 0;
  float left_total = 0;
  float foot_probs;
  
  int row_counter = 1;
  for (TableRow row : table.rows()) {
    
      /*
      int count = row.getInt("count");
      int x_coord = row.getInt("x_screen");
      int y_coord = row.getInt("y_screen");
      draw_circle(count, x_coord, y_coord);
      */
      
      
      int zone = row.getInt("Zone");
      print("ROW = ",row_counter ," Zone = ", zone, "\n");
      
      if(zone == -1){
        continue;
      }
      
      int goal = row.getInt("Goal");
      
      goal_zone_totals[zone - 1] ++;
      
      if(goal == 1){
        goal_zone_scored[zone - 1]++;
      }
      
      print(goal_zone_totals[zone - 1], " \n");
      row_counter++;
      
      foot = row.getString("Foot");
      
      if(foot.equals("R") == true){
        //print("YEP-" + foot + "-\n");
        right_total++;
        if(goal==1){
          right++;
        }
        
      } else{
        left_total++;
        if(goal==1){
          left++;
        }
      }
      
  }
  
  for(int i = 0; i < 9; i++){
    
    goal_zone_prob[i] = goal_zone_scored[i]/goal_zone_totals[i];
    print("Prob ",i+1,": ",goal_zone_prob[i], "\n");
  }
  
  shot_direction[0] = int(goal_zone_totals[0]) + int(goal_zone_totals[3]) + int(goal_zone_totals[6]);
  shot_direction[1] = int(goal_zone_totals[1]) + int(goal_zone_totals[4]) + int(goal_zone_totals[7]);
  shot_direction[2] = int(goal_zone_totals[2]) + int(goal_zone_totals[5]) + int(goal_zone_totals[8]);
  
  foot_probs = right/right_total * 100;
  right_foot_prob = int(foot_probs);
  print(right_foot_prob + "\n\n");
  
  
  //print(right);
  //print(left);
  
  foot_probs = left/left_total * 100;
  left_foot_prob = int(foot_probs);
  
  print(left_foot_prob + "\n\n");
  
}

void draw() {
  
  
  //ORGANISE background colours
  background(#e6e6e6);
  //background(#79F582);
  
  //BEHIND GOAL COLOUR
  //rect()
  
  //PITCH COLOUR
  strokeWeight(2);
  fill(#b5ed95);
  stroke(#b5ed95);
  rect(0,H/3,W,2*H/3);
  
  // Draw the image to the screen at coordinate (0,0)
  //image(img,0,0);
  
  
  
  //Divide up goal into sections
  strokeWeight(4);
  
  stroke(0);
  
  //Horizontal
  line(W/4,H/9 + 2*H/27,3*W/4,H/9 + 2*H/27);
  line(W/4,H/9 + 4*H/27,3*W/4,H/9 + 4*H/27);
  
  //Vertical
  line(W/4+W/6,H/9,W/4+W/6,H/3);
  line(W/4+2*W/6,H/9,W/4+2*W/6,H/3);
  
  
  
  //Draw the goal using rect
  strokeWeight(10);
  
  stroke(0);
  noFill();
  rect(W/4,H/9,W/2,2*(H/9));
  
  //Draw lines on the pitch
  
  stroke(255);
  line(0,H/3,W,H/3);
  
  line(W/12,H/2,W/6,H/3);
  line(11*W/12,H/2,5*W/6,H/3);
  
  line(W/12,H/2,11*W/12,H/2);
  
  
  
  
  
  
  
  
  
  
  //THIS SECTION BEGINS ENCODING THE DATA
  
  //FIRST THING TO ENCODE IS PIE CHARTS
  //
  
  //Find radian data
  int angles[] = new int[2];
  float new_angle;
  int percentage;
  for(int i = 0; i < goal_zone_prob.length; i++){
    
    new_angle = 360 * goal_zone_prob[i];
    
    angles[0] = int(new_angle);
    angles[1] = 360 - int(new_angle);
    

    pieChart(120,angles, x_coord_zone[i], y_coord_zone[i]);

    percentage = int((new_angle/360) * 100);
    
    textSize(50);
    textAlign(CENTER);
    fill(#2b5c8a);
    text(percentage+"%", x_coord_zone[i]-120, y_coord_zone[i]); 
    fill(#9e3d22);
    text(100 - percentage +"%", x_coord_zone[i]+120, y_coord_zone[i]); 
  
  }
  
  //ENCODE THE SHOT LINES
  fill(#b5ed95);
  
  strokeWeight(shot_direction[0]);
  //line(W/2,2*H/3, x_coord_zone[0], H/3+50);
  bezier(W/2,2*H/3, W/2,H/2,  x_coord_zone[0],H/2, x_coord_zone[0], H/3+75);
  
  
  strokeWeight(shot_direction[1]);
  line(W/2,2*H/3, x_coord_zone[1], H/3+40);
  
  strokeWeight(shot_direction[2]);
  //line(W/2,2*H/3, x_coord_zone[2], H/3+50);
  bezier(W/2,2*H/3, W/2,H/2,  x_coord_zone[2],H/2, x_coord_zone[2], H/3+60);
  
  
  float total = shot_direction[0] + shot_direction[1] + shot_direction[2];
  fill(0);
  textAlign(CENTER);
  textSize(50);
  text(round((shot_direction[0]/total) * 100) + "%", W/4 + 50, H/2-200); 
  
  fill(0);
  textAlign(CENTER);
  textSize(50);
  text(round((shot_direction[1]/total) *100) + "%",W/2 - 100, H/2-200);
  
  fill(0);
  textAlign(CENTER);
  textSize(50);
  text(round((shot_direction[2]/total) * 100) + "%",W/2 + 250, H/2-200); 
  
  fill(0);
  textAlign(CENTER);
  textSize(50);
  text("Shot Direction Percentages",3* W/4 + 50, H/2+100); 
  
  
  
  
  //DRAW FOOTBALL
  imageMode(CENTER);
  image(img, W/2, 2*H/3);
  //ellipse(W/2,2*H/3,100,100);
  
  
  /*
  
  //Bar charts for right and left footed players
  
  fill(0);
  textAlign(CENTER);
  textSize(40);
  text("Chance of a Left Footed Player Scoring", W/4, 2*H/3); 
  fill(#4e79a7);
  text(left_foot_prob + "%", W/4, 2*H/3+100); 
  
  fill(0);
  text("Chance of a Right Footed Player Scoring", 3*W/4, 2*H/3); 
  fill(#4e79a7);
  text(right_foot_prob + "%", 3*W/4, 2*H/3+100); 
  
    
  stroke(0); //set fill colour to bright blue
  strokeWeight(4);  // Default
  line(W/8, 3*H/4 , 7*W/8, 3*H/4);
  line(W/8, 3*H/4 +70 , 7*W/8, 3*H/4 +70);
  line(W/8, 3*H/4 +140, 7*W/8, 3*H/4 +140);
  line(W/8, 3*H/4 +210, 7*W/8, 3*H/4 +210);
  line(W/8, 3*H/4 +280, 7*W/8, 3*H/4 +280);
  line(W/8, 3*H/4 +350, 7*W/8, 3*H/4 +350);
  
  fill(0);                         // STEP 4 Specify font color
  text(  "0%",  7*W/8 +50, 3*H/4 +350);   // STEP 5 Display Text
  text(  "20%", 7*W/8 +50, 3*H/4 +280);   // STEP 5 Display Text
  text(  "40%", 7*W/8 +50, 3*H/4 +210);   // STEP 5 Display Text
  text(  "60%", 7*W/8 +50, 3*H/4 +140);   // STEP 5 Display Text
  text(  "80%", 7*W/8 +50, 3*H/4 +70);   // STEP 5 Display Text
  text(  "100%", 7*W/8 +50, 3*H/4);   // STEP 5 Display Text
  
  fill(#4e79a7);
  stroke(#4e79a7);
  rect(W/4 - 30, 3*H/4+350, 50, -(350 * left_foot_prob/100));
    
  rect(3*W/4 - 30, 3*H/4+350, 50, -(350 * right_foot_prob/100));
  
  */
  
  save("goals.PNG");
  exit();
  
}

void draw_circle(int count, int x_coord, int y_coord ){
  if(count == -999){ //Water pump
    fill(#025FF0);
    ellipse(x_coord, y_coord, 8, 8);
  
  }else{
    fill(#FF0324);
    ellipse(x_coord, y_coord, count, count);
  
  }
  
  
}

void draw_dashed_line(int x1, int y1, int x2, int y2){
  
}


void pieChart(float diameter, int[] data, int x, int y) {
  color green = color(#2b5c8a);
  color red = color(#9e3d22);
  strokeWeight(4);
  stroke(0);
  float lastAngle = 0;
  for (int i = 0; i < data.length; i++) {
    //float gray = map(i, 0, data.length, 0, 255);
    
    if(i == 0){
      fill(green);
    } else{
      fill(red);
    }
    
    arc(x, y, diameter, diameter, lastAngle, lastAngle+radians(data[i]));
    lastAngle += radians(data[i]);
  }
}
