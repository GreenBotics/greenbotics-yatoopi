tubing_dia     = 16;//based on tubing OD of 16 mm
aquarium_walls_thickness = 5;//5mm thick glass 

angle_mount_thickness = 3;

//cornerTubingHolder(tubing_dia,angle_mount_thickness,40,aquarium_walls_thickness);

sideTubingHolder(tubingDia=tubing_dia, height =30, length=20, thickness=3, snapOnThickness= angle_mount_thickness);

//clip(height=40,length=20,innerDistance=5,thickness=3);
//steppedConnector(16,18,2.5,length=15);
module cornerTubingHolder(tubingDia, thickness, mountHeight, snapOnThickness){
  width = 40;
  length=40;


  module body(){
    xOffset = snapOnThickness + thickness;
    union(){
      cube([width,length,thickness]);

       cube([width,thickness,mountHeight]);
      translate([snapOnThickness*2,xOffset,0]) cube([width-snapOnThickness*2,thickness,mountHeight]);

      cube([thickness,length,mountHeight]);
      translate([xOffset,snapOnThickness*2,0]) cube([thickness,length-snapOnThickness*2,mountHeight]);
    }
    
  }

  module holes(){
    translate([width/2+5,length/2+5,0]) cylinder(h=50,r=tubingDia/2,center=true);
  }

  difference () {
    body();
    holes();
  }
}


module sideTubingHolder(tubingDia, height, length, thickness, snapOnThickness, tubingMountHeight=20, holesNb){
  tubingDia = 18;
  od = tubingDia + thickness*2;
  module body(){
   
    clip(height=height,length=length,innerDistance=snapOnThickness,thickness=thickness);

    translate([snapOnThickness+thickness*3,length/2,tubingMountHeight]) rotate([0,90,90]) steppedConnector(14,16,1.5,length=15);

    mirror([0,1,0])translate([snapOnThickness+thickness*3,-length/2,tubingMountHeight]) rotate([0,90,90]) steppedConnector(14,16,1.5,length=15);

    hull(){
      translate([snapOnThickness+thickness*3,0,tubingMountHeight]) rotate([0,90,90]) cylinder(h=length,r=tubingDia/2 );

      translate([thickness,0,tubingMountHeight-tubingDia/2]) cube(size=[thickness,length,tubingDia]);
    }

  }

  module holes(){
    //rotate([0,90,90]) translate([0,10,0]) cylinder(h=length,r=tubingDia/2 );
  }

  difference () {
    body();
    holes();
  }
}


module clip(height,length,innerDistance,thickness)
{
  dia = innerDistance+thickness*2;
  id  = innerDistance;
  clearance = 0.1;

  difference(){
    hull(){
      translate([0,length,height])  rotate([90,0,0]) cylinder(r=dia/2,h=length);
      translate([-dia/2,0,0])cube([dia,length,height]);
      //cube([thickness,length,height]);
    }

    hull(){
      translate([0,length,height])  rotate([90,0,0]) rotate([0,0,45])cylinder(r=id/2,h=length+clearance,$fn=4);
      translate([-id/2,0,-clearance])cube([id,length+clearance,height]);
    }
  }
}


module steppedConnector(minId,maxId,thickness,length,steps=4,stepDepth=0.5){
  minOD = minId + thickness * 2;
  maxOD = maxId + thickness * 2;
  clearance = 0.1;

  stepLength = length/steps;

  difference(){
    union(){
      for ( i = [0 : steps] )
      {
        minI = (minOD-stepDepth*i) /2;
        maxI = (maxOD-stepDepth*i) /2;

        translate([0,0,stepLength*i])
         cylinder(r1 = maxI, r2 = minI, h=stepLength);
      }
    }
   
    cylinder(r1 = minId/2, r2 = maxId/2,h=length*2+clearance*2);
  }
}

module steppedConnector2(minId,maxId,thickness,length,steps=4,stepDepth=0.5){
  minOD = minId + thickness * 2;
  maxOD = maxId + thickness * 2;
  clearance = 0.1;

  stepLength = length/steps;

  difference(){
    union(){
      for ( i = [0 : steps] )
      {
        minI = (minOD-stepDepth*i) /2;
        maxI = (maxOD-stepDepth*i) /2;

        translate([0,0,stepLength*i])
         cylinder(r1 = maxI, r2 = minI, h=stepLength);
      }
    }
   
    cylinder(r1 = minId/2, r2 = maxId/2,h=length*2+clearance*2);
  }
}