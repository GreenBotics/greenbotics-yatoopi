

fudge = 0.1;
bedCorner();

//boltHole();

module bedCorner(height=100,radius=18, mountBoltDia=4, mountBoltsNb=4, mountHeightsFront=[20,60], mountHeightsSide=[40,80], 
  baseRadius=36, baseHeight=5,baseBorderWidth=15, res=50){
  
  mountBoltsStuff = height / mountBoltsNb;
  list1 = [1,2,-1,5,4];
  
  difference(){
    intersection(){
      cylinder(r=radius,h=height,$fn=res);
      translate([0,0,0])cube(size=[radius,radius,height]);
    }
    
    
    for (z = mountHeightsFront) 
    {
        translate([radius,radius/2,z]) #rotate([0,90,180]) boltHole(dia=mountBoltDia,h=radius+fudge,$fn=res); 
    }
    
    for (z = mountHeightsSide) 
    {
        translate([radius/2,radius,z]) #rotate([0,90,-90]) boltHole(dia=mountBoltDia,h=radius+fudge,$fn=res);  
    }
    
  }
  translate([0,0,-baseHeight])  
  bedCornerSupport(radius=baseRadius,height=baseHeight, borderWidth=baseBorderWidth);
}


module bedCornerBase(height=4,radius=18, res=50){
  
    #intersection(){
      cylinder(r=radius,h=height,$fn=res);
      translate([0,0,0])cube(size=[radius,radius,height]);
    }
}

module bedCornerSupport(height=4,radius=18,borderWidth=10, res=50){
   notchDia    = 4;
   notchOffset = 8;
   notchDepth  = 2; 
  
   difference(){
   
     union(){
       difference(){
        translate([-borderWidth,-borderWidth,0]) cube(size=[radius/2+borderWidth,radius/2+borderWidth,height]);
        #cube(size=[radius/2,radius/2,height]);
       }
       bedCornerBase(height=height, radius = radius/2, res=res);
     }
   
    //now add small holes so we can stack corners
    cylinder(r=notchDia/2,h=notchDepth,$fn=40);   
    translate([notchOffset,notchOffset,0]) cylinder(r=notchDia/2,h=notchDepth,$fn=40); 
    translate([notchOffset,-notchOffset,0]) cylinder(r=notchDia/2,h=notchDepth,$fn=40);  
    translate([-notchOffset,notchOffset,0]) cylinder(r=notchDia/2,h=notchDepth,$fn=40); 
    translate([-notchOffset,-notchOffset,0]) cylinder(r=notchDia/2,h=notchDepth,$fn=40); 
   }
   
   
}





module boltHole(dia=4,h=10,headDia=8,headDia2=12,headHeight=8,$fn=50){
  //3 height, min 4 to 8
  translate([0,0,headHeight])cylinder(h=3,r2=4/2,r1=8/2);
  
  cylinder(r=dia/2,h=h,$fn=$fn);
  cylinder(r2=headDia/2,r1=headDia2/2,h=headHeight,$fn=$fn);
}
