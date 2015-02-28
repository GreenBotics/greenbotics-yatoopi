//bed clips, to hold liner etc 

fudge = 0.1;
bedClip(jawSpacing=18);//based on wooden walls of the bed of 18mm


module bedClip(jawSpacing=18,jawLength=40,jawThickness=10,wallsThickness=3.5,toothSize=1,toothLength=10){

  armOffset = (jawSpacing+wallsThickness)/2;
  armLen    = jawLength + wallsThickness;
  
  module arm(){
    cube(size=[wallsThickness,armLen,jawThickness],center=true);
    
    //tooth
    translate([wallsThickness/2+toothSize/2,-(armLen-toothLength)/2,0])
    cube(size=[toothSize,toothLength,jawThickness],center=true);
 }

  union(){
    translate([-armOffset,0,0]) arm();
    translate([armOffset,0,0]) mirror([1,0,0]) arm();
    
    translate([0,(armLen-wallsThickness)/2,0]) 
    cube(size=[jawSpacing,wallsThickness,jawThickness],center=true);
  }
}
