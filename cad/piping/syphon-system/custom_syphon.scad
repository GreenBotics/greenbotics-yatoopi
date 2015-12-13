// A Hydroponic mechanical syphon
adjust = 0.01;

length=45;
main_dia= 52;//should be inner diameter of media guard
walls = 2.5;
inlets_dia=8;

body_length = length;
center_hole_dia = main_dia-(walls*2);

bucket_outlet_dia=10;

module bucket_body(height,dia){
	union () {		
		cylinder(h=height,d=dia,center=false,$fn=100);
	}
}
module bucket_holes(height, dia, holeDia, holeOffset){
	union(){
		translate ([dia/2,0,height/2])cube(size=[dia,dia,height+adjust*2],center=true);

		translate ([0,0,walls]) difference(){
			innerDia= dia-walls*2;
			innerHeight = height-walls;
			cylinder(h=height,d=innerDia,center=false,$fn=100);
			translate ([innerDia/2-walls,0,innerHeight/2])cube(size=[innerDia,innerDia,innerHeight],center=true);
		}

		translate ([holeOffset,0,0]) cylinder(h=walls+adjust,d=holeDia,center=false,$fn=15);

	}
}

module bucket(height, dia, holeDia, holeOffset){

	difference () {
		bucket_body(height, dia);
		bucket_holes(height, dia, holeDia, holeOffset);
	}

}

///////////////
module basket(){
	
	latch_height = 30;
	latch_width  = 10;
	latch_length = 8;
	latch_hole_width = 5;
	latch_top = 3;

	height = latch_height;
	dia    = main_dia-walls*2-0.5;

	//how far appart are latches
	latch_offset = dia/2-latch_length;

	module latch(){
		translate([0,-latch_length/2,0])
		difference(){
			cube(size=[latch_width,latch_length,latch_height]);
			union(){
				cube(size=[latch_hole_width,latch_length,latch_height-latch_top]);
			}
		}
	}

	for (a =[-1,1])
	{
		translate([0,a*latch_offset,0]) latch();
	}
	
	innerBucker_hole_dia = 3;
	innerBucker_hole_offset = -dia/4;
	//height = body_length;
	//dia    = main_dia;
	//innerBucker_hole_dia = bucket_outlet_dia 
	//innerBucker_hole_offset = 0;

	bucket(height, dia, innerBucker_hole_dia, innerBucker_hole_offset);

}  

//////////
module container(){
	height = body_length;
	dia    = main_dia;
	innerBucker_hole_dia = bucket_outlet_dia;
	innerBucker_hole_offset = 0;

	translate([0,0,-40])
	bucket(height, dia, innerBucker_hole_dia, innerBucker_hole_offset);

}

//bucket();
basket();
container();
//for testing only
//cube([100,100,27],center=true);
//translate([0,0,43]) cube([100,100,35],center=true);


