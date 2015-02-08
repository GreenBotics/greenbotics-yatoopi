


//webcamHolder(side="bottom");
webcamHolder(side="top");



module webcamHolder(side="top"){
  fudge = 0.01;
  length = 61;
  width  = 8;
  height = 3.95;
  wallThickess = 2;
  innerClearance= 0.8;
  innerClearanceTopBottom = 0;
  
  camOpticsDia = 10.2;
  camOpticsOffset=28;
  
  mountHolesDia = 2.1;
  mountHoleStartOffset= 7.6;
  mountHolesEndDist = 4;
  
  pcbThickness         = 2;
  pcbFootOutlineHeight = 0.5;
  pcbFootOutlineWidth  = 0.5;
  
  extMountDia = 3;
  
  fullLength = length + ( wallThickess + innerClearance ) *2;
  fullWidth  = width  + ( wallThickess + innerClearance ) *2;
  fullHeight = height + ( wallThickess + innerClearanceTopBottom ) *2;
  
  innerLength = length + ( innerClearance ) *2;
  innerWidth  = width  + ( innerClearance ) *2;
  innerHeight = height + ( innerClearanceTopBottom ) *2;
  
  pcbFootWidth  = width   - pcbFootOutlineWidth*2;
  pcbFootLength = length - pcbFootOutlineHeight*2;
  pcbFootHeight = 3;
  
  echo("fullHeight",fullHeight);
  
  res=50;
  
  
  difference(){
  
    union(){
    
      difference(){
        cube(size=[fullLength, fullWidth, fullHeight],center=true);
        translate([wallThickess, 0, 0])  cube(size=[innerLength+wallThickess, innerWidth, innerHeight],center=true);
        
        translate([length/2-camOpticsOffset, 0, -fudge]) #cylinder(r=camOpticsDia/2,h=fullHeight/2+fudge,$fn=res);
      };

      
      //pcb outline "feet"
      /*translate([0,0,-innerHeight/2+pcbFootOutlineHeight/2]) 
      difference(){
        cube(size=[length, width, pcbFootOutlineHeight],center=true);
        cube(size=[pcbFootLength, pcbFootWidth, pcbFootOutlineHeight],center=true);
      }
      translate([0,0,-innerHeight/2+pcbFootOutlineHeight/2+pcbThickness]) 
      difference(){
        cube(size=[length, width, pcbFootOutlineHeight],center=true);
        cube(size=[pcbFootLength, pcbFootWidth, pcbFootOutlineHeight],center=true);
      }
      */
      
      
      //bolt mount stuff
      translate([30,(fullWidth+extMountDia)/2,0]) mount( od= extMountDia+wallThickess*2, id=extMountDia, h=fullHeight);
      translate([30,-(fullWidth+extMountDia)/2,0]) mount( od= extMountDia+wallThickess*2, id=extMountDia, h=fullHeight);
      
      translate([-30,-(fullWidth+extMountDia)/2,0]) mount( od= extMountDia+wallThickess*2, id=extMountDia, h=fullHeight);
    }
  
    //TODO: UGH openscad old version : no real variables, asignments etc 
    //cutoffset = -3;
    if(side == "top")
    {
      translate([0,0,-3]) #cube([100,50,6],center=true);
    }
    if(side == "bottom")
    {
      translate([0,0,3]) #cube([100,50,6],center=true);
    }
    
    
  }
  
  //pcb foot : should not be cut in half
  if(side == "top"){
    translate([-length/2+1.5,0,+pcbFootHeight/2]) 
    cube(size=[3, innerWidth, pcbFootHeight],center=true);
  }
}


module mount(od=5, id=3, h=10,res=20){

  difference(){
      cylinder(r=od/2,h=h,$fn=res,center=true);
      cylinder(r=id/2,h=h,$fn=res,center=true); 
  }

}
