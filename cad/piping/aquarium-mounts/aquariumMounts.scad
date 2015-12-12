tubing_dia     = 16;//based on tubing OD of 16 mm
tubing_offset  = tubing_dia/2 +7;//offset of center of tubing compared to aquarium inner corner
aquarium_walls_thickness = 5;//5mm thick glass 

angle_mount_thickness = 3;

//cornerTubingHolder(tubingDia=tubing_dia,tubingOffset=tubing_offset,thickness=angle_mount_thickness,mountHeight=40,snapOnThickness=aquarium_walls_thickness);

//tubing_dia
sideTubingHolder(tubingDia=22, height =30, length=20, thickness=3, snapOnThickness= aquarium_walls_thickness, cutSize=3);

//clip(height=40,length=20,innerDistance=5,thickness=3);
//steppedConnector2(id=15.5,minOd=17.5,maxOd=20.5,length=15);

module cornerTubingHolder(tubingDia, tubingOffset, thickness, mountHeight, snapOnThickness){
  width = 40;
  length=40;
  height= mountHeight;
  clearance = 0.1;
  baseThickness = thickness *2;

  offset = snapOnThickness+thickness;
  offset2 = thickness*1.5;
  cornerDia = 10;

  rheight = mountHeight -thickness;
  mountOffset = thickness;

  wallsPlusCutout = snapOnThickness +thickness*2;
  aquariumInnerStart = wallsPlusCutout - thickness;

  tubeXOffset = aquariumInnerStart + tubingOffset;
  tubeYOffset = aquariumInnerStart + tubingOffset;

  module body(){
    union(){   
      //base, with rounded corners
      hull(){
        translate([cornerDia/2,cornerDia/2,0]) cylinder(r=cornerDia/2,h=height, $fn=30);
        translate([width - cornerDia,length - cornerDia,0]) cube([cornerDia,cornerDia,height]);

        translate([width - cornerDia,0,0]) cube([cornerDia,cornerDia,height]);
        translate([0,length - cornerDia,0]) cube([cornerDia,cornerDia,height]);
      }
    }
    
  }

  module holes(){
    //main tubing hole
    translate([tubeXOffset,tubeYOffset,- clearance]) cylinder(h=height + clearance,r=tubingDia/2);

    //main cutout
    cutoutWidth = width-wallsPlusCutout;
    cutoutLength = length-wallsPlusCutout;
    difference(){
      translate([width-cutoutWidth+ clearance ,length-cutoutLength +clearance ,baseThickness]) cube([cutoutWidth,cutoutLength,rheight + clearance]);

      //tubing stabilizer
      translate([aquariumInnerStart,aquariumInnerStart,thickness]) #cube([tubeXOffset - tubingDia/2 ,tubeXOffset - tubingDia/2 ,rheight + clearance]);
    }

    //mount cutouts
    mountLenOffset = thickness + snapOnThickness/2;
    mountLengthW = width - mountLenOffset;
    mountLengthL = length - mountLenOffset;
    translate([mountLenOffset,mountOffset,thickness]) cube([mountLengthW,snapOnThickness,mountHeight]);
    translate([mountOffset,mountLenOffset,thickness]) cube([snapOnThickness,mountLengthL,mountHeight]);

    //corner cutouts, to not damage silicone joints
    translate([offset,offset,thickness]) cylinder(h=mountHeight,r=thickness*2,$fn=30);
    translate([offset2,offset2,thickness]) cylinder(h=mountHeight,r=thickness*0.8,$fn=30);
  }

  difference () {
    body();
    holes();
  }
}


module sideTubingHolder(tubingDia=16, height=40, length=20, thickness=3, snapOnThickness=5, tubingMountHeight=15, cutSize=0, cutAngle=45){
  clearance = 0.1;
  tubingDia = tubingDia + clearance*2;
  od = tubingDia + thickness*2;
  
  tubingOffset = snapOnThickness/2+tubingDia/2+thickness;

  //actually start from top 
  rTubingMountHeight = height - tubingMountHeight;

  module body(){
    //main clip
    clip(height=height,length=length,innerDistance=snapOnThickness,thickness=thickness);
    //translate([snapOnThickness+thickness*3,length/2+5,tubingMountHeight]) rotate([0,90,90]) steppedConnector2(id=15.5,minOd=17.5,maxOd=20.5,length=15);
    //mirror([0,1,0])translate([snapOnThickness+thickness*3,-length/2+5,tubingMountHeight]) rotate([0,90,90]) steppedConnector2(id=15.5,minOd=17.5,maxOd=20.5,length=15);
    hull(){
      translate([tubingOffset,0,rTubingMountHeight]) rotate([0,90,90]) cylinder(h=length,r=od/2,$fn=50 );
      translate([thickness,0,rTubingMountHeight-od/2]) cube(size=[thickness,length,od]);
    }

  }

  module holes(){
    //main tubing hole
    tubingLength = length+clearance*2;
    tubingHoleDia= tubingDia/2;
    #translate([tubingOffset,-clearance,rTubingMountHeight]) rotate([0,90,90]) cylinder(h=tubingLength,r=tubingHoleDia );

    //optional cut in main loop

    #translate([tubingOffset,0,rTubingMountHeight+cutSize/2]) rotate([0,cutAngle,0]) cube(size=[cutSize,length,od/2]);
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
      translate([0,length,height])  rotate([90,0,0]) cylinder(r=dia/2,h=length,$fn=30);
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

module steppedConnector2(id,minOd,maxOd,length,tipLength=1.5,steps=3,stepDepth=0.5,stepDistance=0){
  //minOD = minId + thickness * 2;
  //maxOD = maxId + thickness * 2;
  clearance = 0.1;
  minOD = minOd;
  maxOD = maxOd;

  stepLength = length/steps;

  difference(){
    union(){

      //translate([0,0,tipLength])
      for ( i = [0 : steps-1] )
      {
        minI = (minOD-stepDepth*i) /2;
        maxI = (maxOD-stepDepth*(i+1)) /2;

        translate([0,0,(stepLength+stepDistance)*i])
          cylinder(r2 = minI, r1 = maxI, h=stepLength);
      }

      tipOd = (minOD-stepDepth*steps) /2;
      translate([0,0,length ]) cylinder(r2 = tipOd, r1 = tipOd, h=tipLength);

      cylinder(r = minOd/2, h=length);
    }

    //cylinder(r2 = minOd, r1 = maxOd, h=length);
   
    translate([0,0,-clearance]) cylinder(r2 = id/2, r1 = id/2,h=length*2+clearance*2);
  }
}

module tubingAdaptator(){

}