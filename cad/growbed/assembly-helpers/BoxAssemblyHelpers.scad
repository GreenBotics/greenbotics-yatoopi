// An L shaped wooden box assembly / screwing helper

assemblyHelper();

module assemblyHelper(plankThickness=18,screwDia=4,wallSize=4,thickness=5){

  height = plankThickness;
  width    = wallSize*2 + screwDia;
  fudge= 0.1;
  
  module side(){
      difference(){
        translate([height/2-thickness/2,0,thickness/2]) cube([height+thickness,width,thickness],center=true);
        
        
        translate([height/2,0,0]) 
          hull(){
            cylinder(r=screwDia/2+fudge,h=thickness+fudge,$fn=20);
            translate([0,-(screwDia+fudge)/2,0])cube([height/2,screwDia+fudge,thickness+fudge]);
          }
      }
  }
  
  rotate([0,-90,0]) union(){
    side();
    rotate([0,90,0]) translate([0,0,-thickness]) side();
    //translate([-thickness-0.1,-width/2,0]) cube([thickness,width,thickness+fudge]);
  }
}
