// Media guard , to prevent media (clay pellets etc) + roots
//from clogging the outflow

mediaGuard();

module mediaGuard(height=100,innerDia=52,wallSize=2.5, baseLip=10, baseLipHeight=4, res=30){
  fullDia = innerDia+wallSize*2;
  fudge= 0.1;
  
  bottomNoWaterZoneHeight = 2;//how heigh is the zone withouth holes at the base of the guard
  orientedWaterZoneHeight = 18; 
  orientedWaterZoneAlign  = "front"; //can be "front","back"
  topNoWaterZoneHeight = 10;
  
  holesDia = 5;
  holesRes = 16;
  vertHolesDist = holesDia + 4;
  
  radHolesNb = 12;
  
  module baseHole(length = fullDia){
    rotate([0,90,0]) cylinder(r=holesDia/2,h=length,$fn=holesRes,center=true);
  }
  
  module holes(){
    fullHolesZoneHeight = height - orientedWaterZoneHeight - bottomNoWaterZoneHeight - topNoWaterZoneHeight;
    verHolesNb         = (fullHolesZoneHeight-vertHolesDist) / vertHolesDist;
    layerRot  = (360 / radHolesNb)*1.5;// how much do we rotate holes for each "hole layer" so they are not aligned
    
    //for oriented holes region
    orientedHolesVerNb = orientedWaterZoneHeight / vertHolesDist;
    orientedHolesLength= fullDia/2;
    orientedHolesOffset = orientedWaterZoneAlign == "front" ? fullDia/2 : -fullDia/2;
    orientedHolesLayerRot  = (360 / radHolesNb)*0.5;// how much do we rotate holes for each "hole layer" so they are not aligned
    echo("orientedHolesVerNb",orientedHolesVerNb,"verHolesNb",verHolesNb,"orientedHolesOffset",orientedHolesOffset);
    
    
    //main hole
    translate([0,0,-fudge/2]) cylinder(r=innerDia/2,h=height+fudge,$fn=res);
    
    //all sided holes
    for( j = [0 : verHolesNb ] )
    {
      for ( i = [0 : radHolesNb/2] )
      {
          rotate( i * 360 / radHolesNb + ( j * layerRot ), [0, 0, 1])
          
          translate([0, 0, bottomNoWaterZoneHeight+orientedWaterZoneHeight+holesDia+j*vertHolesDist])
          baseHole();
      }
    }
    
    //oriented (one sided) holes
    for( j = [0 : orientedHolesVerNb-1 ] )
    {
      for ( i = [0 : radHolesNb/2] )
      {
          rotate( i * 360 / radHolesNb + ( j * orientedHolesLayerRot ), [0, 0, 1])
          translate([orientedHolesOffset, 0, bottomNoWaterZoneHeight+holesDia+j*vertHolesDist])
          baseHole(orientedHolesLength);
      }
    }
    
    
  }
  
  difference(){
        union(){
          cylinder(r=fullDia/2,h=height,$fn=res);
          cylinder(r=(fullDia+baseLip*2)/2, h=baseLipHeight);
        }
    holes();
  }
  
  
  
}
