// A mechanical syphon for Aquaponics

//TODO: implement computing hole sizes based on this
inputFlow = 1;//in l/min
desiredTime = 0;//in minutes
containerVolume = 150;//Liter
//all these should determin the size of outflow hole for the bucket etc


///
adjust = 0.05;

length=70;
main_dia= 52;//should be inner diameter of media guard
walls = 2.5;
inlets_dia=8;

body_length = length;
center_hole_dia = main_dia-(walls*2);



module bucket_body(height,dia){
	union () {		
		cylinder(h=height,d=dia,center=false,$fn=150);
	}
}

module halfCircle(dia, height, cutOffset=0){
	difference(){
		union(){
			cylinder(h=height,d=dia,center=false,$fn=150);
		}
		translate([-dia/2-cutOffset,0,height/2+adjust/2]) cube(size=[dia,dia,height+adjust*2],center=true);
	}
}

module bucket_holes(height, dia, holeDia, holeOffset, cutOffset=0){
	bottomThickness = 2;

	union(){
		translate ([dia/2-cutOffset,0,height/2+adjust/2])cube(size=[dia,dia,height+adjust*2],center=true);

		translate ([0,0,bottomThickness]) 
			difference(){
				innerDia= dia-walls*2;
				innerHeight = height-walls;
				cylinder(h=height,d=innerDia,center=false,$fn=100);
				translate ([innerDia/2-walls-cutOffset,0,innerHeight/2])cube(size=[innerDia,innerDia,innerHeight+adjust*2],center=true);
			}

		//outlet hole
		translate ([holeOffset-cutOffset+holeDia/2,0,-adjust]) cylinder(h=bottomThickness+adjust*2,d=holeDia,center=false,$fn=50);
	}
}

module bucket(height, dia, holeDia, holeOffset, cutOffset=0){
	difference () {
		bucket_body(height, dia);
		bucket_holes(height, dia, holeDia, holeOffset, cutOffset);
	}
}


module hingeAttach(width=3, baseWith=3, baseOffset=1.5, dia=6, holeDia=3){
	offset = 10;

	difference(){
		hull(){
			cylinder(h=width,d=dia,center=false,$fn=20);
			translate([baseOffset,dia/2,width/2]) cube(size=[baseWith,dia,width],center=true);
		}
		translate([0,0,-adjust]) cylinder(h=width+adjust*2,d=holeDia,center=false,$fn=20);
	}
}


module hinged_valve(valve_dia=40,base_dia=52,base_height=5,valve_height=3){
	overlap = 3; //how much overlap between valve and base

	hinge_od = 3.25;
	hinge_id = 1.75;

	base_id     = valve_dia-overlap*2;
	
	hinge_z_offset = base_height+valve_height/2;
	hinge_x_offset = 0;
	hinge_y_offset = base_dia/2;

	hinge_il = valve_dia ;//inner length
	hinge_ol = (base_dia - hinge_il)/2;//outer length : ie for both sides

	%translate([0,0,base_height]){
		//articulated valve top
		halfCircle(valve_dia,valve_height);

		//hinge
		translate([hinge_x_offset, 0, hinge_z_offset - base_height ]) rotate([0,90,90]) 
			difference(){
				cylinder(h=hinge_il,d=hinge_od,center=true,$fn=50);
				cylinder(h=hinge_il,d=hinge_id,center=true,$fn=50);
			}
		//top attachement
		translate([valve_dia/2-walls,1.5,valve_height+5]) rotate([90,-180,0]) hingeAttach(baseOffset=0);
	}
	


	//base 
	difference(){
		union(){
			halfCircle(base_dia,base_height,0.001);

			for (a =[-1,1]){
				hull(){
					translate([hinge_x_offset,(hinge_y_offset)*a,hinge_z_offset])
						rotate([0,90,-90*a]) cylinder(h=hinge_ol,d=hinge_od, $fn=50);
					
					translate([0,(hinge_y_offset-hinge_od+0.25)*a,hinge_z_offset-hinge_od/3.5])
						rotate([0,0,-180*a])cube(size=[hinge_od,hinge_ol,hinge_od/2],center=true);
					
				}
			}			
		}
		translate([0,0,-adjust]) halfCircle(base_id,base_height+adjust*2);
	}

}



module hingeLever(distance=40,width = 5, dia=6, holeDia=3){
	
	difference(){
		hull(){
			for (a =[-1,1])
			{
				translate([a*distance/2,0,0]) cylinder(h=width,d=dia,center=true,$fn=20);
			}	
		}
		for (a =[-1:1])
		{
			translate([a*distance/2,0,0]) cylinder(h=width+adjust*2,d=holeDia,center=true,$fn=20);
		}	
		
	}
}

///////////////
module basket(height=30){

	xtraClearance = 0.5;
	
	latch_height = height;
	latch_width  = 10;
	latch_length = 8;
	latch_hole_width = 5;
	latch_top = 3;

	dia    = main_dia-walls*2-xtraClearance;

	//how far appart are latches
	latch_offset = dia/2-latch_length;
	//overall x axis offset
	start_offset = walls +xtraClearance/2;

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
		//translate([-start_offset,a*latch_offset,0]) latch();
	}

	translate([-dia/2+walls/2+1.8,1.5,height+5]) rotate([90,-180,0]) hingeAttach();
	
	innerBucker_hole_dia = 3;
	innerBucker_hole_offset = -dia/4;
	//height = body_length;
	//dia    = main_dia;
	//innerBucker_hole_dia = bucket_outlet_dia 
	//innerBucker_hole_offset = 0;

	bucket(height, dia, innerBucker_hole_dia, innerBucker_hole_offset, start_offset);

}  

//////////
module container(height=40,dia=30){
	innerBucker_hole_dia = 18;
	innerBucker_hole_offset = -10;

	inlet_dia    = 10;
	inlet_height = 60;
	inlet_length = walls+adjust*2;
	inlet_width  = dia-5;
	inlet_lip_length = walls + 3;
	inlet_lip_height = 1;

	//for valve
	base_height  = 5;
	valve_height = 3;
	hinge_od = 3.25;
	hinge_id = 1.75;

	difference(){
		union(){
			bucket(height, dia, innerBucker_hole_dia, innerBucker_hole_offset);
			translate([-0,1.5,height+5]) rotate([90,-180,0]) hingeAttach();


			//translate([-inlet_lip_length/2,0,inlet_height-inlet_dia/2]) 
			//	cube(size=[inlet_lip_length, inlet_width, inlet_lip_height],center=true);

			//base with hinged valve
			hinged_valve(	base_height = 5, valve_height = 3);
		}

		//hinge cutout
		hinge_z_offset = base_height+valve_height/2;
		translate([0,0,hinge_z_offset])  rotate([90,-180,0]) cylinder(h=dia,d=hinge_id,center=true,$fn=20);
		translate([0,0,hinge_z_offset])  rotate([90,-180,0]) cylinder(h=40,d=hinge_od,center=true,$fn=20);


		//cut for outlet/inlet
		//translate([-inlet_length/2,0,inlet_height]) rotate([90,0,90]) cylinder(d=inlet_dia, h= inlet_length*2, $fn=20,center=true);
		translate([-inlet_length/2,0,inlet_height]) cube(size=[inlet_length*2, inlet_width, inlet_dia],center=true);

	}


}

//translate([0,0,15])

container(height = body_length, dia=main_dia);
%translate([0,0,25])	basket(height=30);
%translate([0,4,75])  rotate([90,0,0]) hingeLever();

//for testing only
//cube([100,100,27],center=true);
//translate([0,0,43]) cube([100,100,35],center=true);


