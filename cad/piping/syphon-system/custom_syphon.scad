// A mechanical syphon for Aquaponics

//TODO: implement computing hole sizes based on this
inputFlow = 1;//in l/min
desiredTime = 0;//in minutes
containerVolume = 150;//Liter
//all these should determin the size of outflow hole for the bucket etc


///
adjust = 0.05;
hole_adjust = 0.3;

length=70;
main_dia= 51;//should be inner diameter of media guard
walls = 2.5;
inlets_dia=8;

center_hole_dia = main_dia-(walls*2);



module bucket_body(height,dia){
	union () {		
		cylinder(h=height,d=dia,center=false,$fn=150);
	}
}

module halfCircle(dia, height, cutOffset=0, orient=-1){
	difference(){
		union(){
			cylinder(h=height,d=dia,center=false,$fn=150);
		}
		translate([(dia/2-cutOffset)*orient,0,height/2+adjust/2]) cube(size=[dia,dia,height+adjust*2],center=true);
	}
}

module bucket_holes(height, dia, holeDia, holeOffset, cutOffset=0){
	bottomThickness = 2;

	union(){

		innerDia    = dia-walls*2;
		innerHeight = height-bottomThickness+adjust;
		innercutOffset   = walls+cutOffset;

		translate ([0,0,bottomThickness]) halfCircle(innerDia, innerHeight, innercutOffset, orient=1);

		//outlet hole
		translate ([-cutOffset-holeOffset,0,-adjust]) cylinder(h=bottomThickness+adjust*2,d=holeDia,center=false,$fn=100);
	}
}

module bucket(height, dia, holeDia, holeOffset, cutOffset=0){
	difference () {
		halfCircle(dia, height, cutOffset, orient=1);
		bucket_holes(height, dia, holeDia, holeOffset, cutOffset);
	}
}


module hingeAttach(width=3, baseWith=3, baseOffsetX=1.5, baseOffsetZ=0 , dia=6, holeDia=3){
	//baseOffsetX  = baseWith/2
	//baseOffsetZ = dia/2

	translate([0,-baseOffsetZ,0])
	difference(){
		hull(){
			cylinder(h=width,d=dia,center=false,$fn=100);
			translate([baseOffsetX, baseOffsetZ, width/2]) cube(size=[baseWith,dia,width],center=true);
		}
		translate([0,0,-adjust]) cylinder(h=width+adjust*2,d=holeDia,center=false,$fn=50);
	}
}


module hinged_valve(valve_dia=40, valve_height=3, base_dia=52, base_height=5, hinge_od=3.25, hinge_id=1.75, valve_cut=0, generate){
	overlap = 3; //how much overlap between valve and base


	/*hinge_od = 3.25;
	hinge_id = 1.75+hole_adjust;*/

	height = valve_height;
	/*if(hinge_od > valve_height){
		height = valve_height;
	}
	echo("height",valve_height, hinge_od);*/

	base_id     = valve_dia-overlap*2;
	
	hinge_z_offset = base_height+valve_height/2;
	hinge_x_offset = valve_cut;
	hinge_y_offset = base_dia/2;

	hinge_il = valve_dia ;//inner length
	hinge_ol = (base_dia - hinge_il)/2;//outer length : ie for both sides

	attach_holeDia = 3;

	if(generate == "valve"){
		
		translate([0,0,base_height]){
			//articulated valve top
			difference(){
				union(){
					//top attachement
					translate([valve_dia/2-walls,1.5,valve_height]) rotate([90,-180,0]) hingeAttach(baseOffsetX=0,baseOffsetZ=5,holeDia=attach_holeDia);

					//main shape
					halfCircle(valve_dia,height,valve_cut);

					//hinge
					translate([hinge_x_offset, 0, hinge_z_offset - base_height ]) rotate([0,90,90]) 
						cylinder(h=hinge_il,d=hinge_od,center=true,$fn=50);
				}
				union(){
					translate([hinge_x_offset, 0, hinge_z_offset - base_height ]) rotate([0,90,90]) 
						cylinder(h=hinge_il,d=hinge_id,center=true,$fn=50);
				}
				
			}
			
		}
	}

	if(generate == "base"){
		//base 
		difference(){
			halfCircle(base_dia,base_height,0.001);
			translate([0,0,-adjust]) halfCircle(base_id,base_height+adjust*2);
		}
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
module basket(height=30, dia=50, holeDia=3){

	xtraClearance = 0.5;
	
	OD 	= dia;
	ID 	= dia-walls*2;
	vol = (PI * height * ID) /2;

	attach_zOffset = height;
	attach_xOffset = -OD/2+walls/2+1.8;
	attach_holeDia = 3;

	//overall x axis offset
	cut_offset = walls +xtraClearance/2;
	//bucket params
	outHoleLipsWidth        = 2;
	realHalfDia 						= OD/2-cut_offset;

	innerBucker_hole_dia 		= ID /2 - outHoleLipsWidth * 2 - walls*2; 
	innerBucker_hole_offset = realHalfDia/2;

	echo("basket:","height",height,"OD",OD,"ID",ID, "volume",vol,"mm 3" ,"weight:",vol/1000, "gram(s)");
	echo("innerBucker_hole_dia",innerBucker_hole_dia);
	union(){
		//bucket shape itself
		bucket(height, OD, innerBucker_hole_dia, innerBucker_hole_offset, cut_offset);

		//attachement with hole 
		translate([attach_xOffset,walls/2,attach_zOffset]) rotate([90,-180,0]) hingeAttach(baseOffsetZ=5,holeDia=attach_holeDia);
	}
	
}  

//////////
module container(height=40,dia=30,generate="container"){
	innerBucker_hole_dia = 18;
	innerBucker_hole_offset = 0;

	inlet_dia    = 10;
	//for valve
	base_height  = 5;
	hinge_id = 1.75+hole_adjust;
	hinge_od = hinge_id+3;
	hinge_il = 40;
	valve_height = hinge_od;
	hinge_z_offset = base_height+valve_height/2;
	hinge_x_offset = 1.75;

	//for inlet wall
	inletWall_zOffset   = hinge_z_offset+35;
	inletWall_height = height-inletWall_zOffset;
	inletWall_width  = 40;
	inletWall_thickness = 2.7;

	guide_extra = 1.75;
	guide_side_width = (dia-inletWall_width)/2;
	inletWall_thickness_real = walls+guide_extra;
	guide_actualCenter_xOffset = -walls+inletWall_thickness_real/2;//since the guide is not centered on zero, we need to offset things 

	guide_zOffset   = 2;//how much of an inset into the bottom we want
	sideRail_width  = 4; //how much of an inset into the sides we want
	guide_thickness = 1.5; //the thickness of the inset
	guide_width     = inletWall_width;
	guide_height    = inletWall_height+guide_zOffset;
	
	gneThick = guide_thickness + walls;

	guide_xOffset = -1;//-inletWall_thickness+guide_thickness/2+0.4;


	ID= dia;
	vol = (PI * height * ID) /2;
	echo("container:","height",height,"ID",ID, "volume",vol,"mm 3" ,"weight:",vol/1000, "gram(s)");
	innerHeight = height/2;
	adJVol = (PI * innerHeight * ID) /2;
	echo("adjusted weight with height",adJVol/1000, "gram(s)");
	echo("inlet wall start at ",inletWall_zOffset,"inletWall height",inletWall_height);

	echo("hinge dia",hinge_id);

	if(generate=="container")
	{
		difference(){
			union(){
				bucket(height, dia, innerBucker_hole_dia, innerBucker_hole_offset);
				
				//hinge attachement, needs to be added after
				%translate([-0,1.5,height+5]) rotate([90,-180,0]) hingeAttach(baseOffsetX=0,baseOffsetZ=5);

				//base with hinged valve
				hinged_valve(	base_dia=dia, base_height = 5, valve_height = hinge_od, generate="base");
				//hinge extra, otherwise walls are too thin
				intersection(){
					union(){
						translate([hinge_x_offset-hinge_od/2,-(dia+adjust)/2,hinge_z_offset-hinge_od/2+adjust])  cube(size=[hinge_od, dia+adjust*2, hinge_od]);
						translate([hinge_x_offset, 0, hinge_z_offset+hinge_od/2])  rotate([90,0,0]) cylinder(h=dia, d=hinge_od, center=true, $fn=100);
					}
					cylinder(d=dia,h=height,$fn=100);
				}


				//holders for "modular inlet wall"
				for (a =[-1,1]){
					translate([0,-dia/2*a,0])
						mirror([0,a-1,0])
						cube(size=[guide_extra, guide_side_width , height]);
				}

				//transition thingy
				transition_dia = 1.75;
				transition_width = inletWall_width+2;
				transition_extraHeight = 5;

				translate([transition_dia,transition_width/2,inletWall_zOffset-transition_extraHeight-transition_dia])
				rotate([90,0,0])
					difference(){
						union(){
							translate([-transition_dia,0,0 ])
							cube(size=[transition_dia,transition_dia,transition_width]);
						translate([-transition_dia,transition_dia,0 ])
							cube(size=[transition_dia,transition_extraHeight,transition_width]);
						}
						cylinder(d=transition_dia*2,h=transition_width,$fn=50);
						
					}
			}

			//hinge cutouts
			translate([hinge_x_offset,0,hinge_z_offset])  rotate([90,-180,0]) cylinder(h=dia,d=hinge_id,center=true,$fn=100);
			translate([hinge_x_offset,0,hinge_z_offset])  rotate([90,-180,0]) cylinder(h=40,d=hinge_od,center=true,$fn=100);
				//front extra
			translate([hinge_x_offset,-hinge_il/2,hinge_z_offset-hinge_od/2+adjust])  cube(size=[hinge_od*2, hinge_il, hinge_od]);
				//top
			translate([hinge_x_offset-guide_extra,-hinge_il/2,hinge_z_offset])  cube(size=[hinge_od, hinge_il, hinge_od]);


			//cuts for "modular inlet wall"
			//main cut
			translate([-inletWall_thickness+adjust,-inletWall_width/2,inletWall_zOffset])  cube(size=[inletWall_thickness, inletWall_width, inletWall_height]);
			
			for (a =[-1,1]){
				translate([guide_actualCenter_xOffset-guide_thickness/2,(-inletWall_width/2-4)*a,inletWall_zOffset-guide_zOffset]) 
					mirror([0,a-1,0])
					cube(size=[guide_thickness, guide_width, guide_height]);
			}
			
		}
	}

	//valve itself
	if(generate == "valve")
	{
		hinged_valve(base_dia=dia,	base_height = 5, valve_cut=hinge_x_offset, valve_dia =hinge_il- adjust*2, valve_height = hinge_od, hinge_od=hinge_od, hinge_id=hinge_id, generate="valve");
	}



		
	//inlet wall itself, print seperatly
	tweaker 							= 0.1;
	inlet_spout_dia       = inlet_dia +2;
	inlet_spout_len       = 3;

	wall_width            = inletWall_width - tweaker * 4 ;
	connector_width       = inletWall_width + sideRail_width * 2 - tweaker * 2;
	connector_thickness   = guide_thickness - tweaker * 2;
	connector_block_width = inletWall_width - tweaker * 1;

	if(generate=="wall"){
		echo("connector_width",connector_width,"vs",inletWall_width+sideRail_width*2);
		echo("connector_thickness",connector_thickness,"vs",guide_thickness);

		translate([0,0,inletWall_zOffset+inletWall_height/2]) 
		mirror([1,0,0])
		difference(){
			union(){
				//main block
				cube(size=[inletWall_thickness_real,inletWall_width,inletWall_height],center=true);

				//mating connector
				translate([0,0,-guide_zOffset/2])
				cube(size=[connector_thickness,connector_width,inletWall_height+guide_zOffset],center=true);
				

				//Spout positive
				translate([inletWall_thickness_real/2,0,0])
					rotate([0,90,0]) cylinder(d=inlet_spout_dia,h=inlet_spout_len, $fn=50);
				
			}
			
			//Spout hole
			translate([-inletWall_thickness_real/2-adjust,0,0]) rotate([0,90,0]) 
				cylinder(d=inlet_dia,h=inletWall_thickness_real+inlet_spout_len+adjust*2, $fn=50);
		}
	}

	if(generate == "hinge"){
		hinge_attach_height = 10;
		//hinge attachement, needs to be added after
		difference(){
			hingeAttach(baseOffsetX=0,baseOffsetZ=14,baseWith=10, width=8);
			translate([0,-2,0])#cube(size=[inletWall_thickness_real,hinge_attach_height,20],center=true);
		}

	}

}

module hole_adaptor(OD =11.1, ID=1, h =2, lipsWidth=2, lipsHeight=0.5, cleareance=0.5){

	//11.1
	rOD= 11.1 - cleareance ;
	lipsOD = OD + lipsWidth*2;
	difference(){
		union(){
			cylinder(d=lipsOD,h=lipsHeight,$fn=100);
			cylinder(d=rOD,h=h,$fn=100);
		}

		//hole
		cylinder(d=ID,h=h+1,$fn=100);
	}

}

/////////////////

basket_OD = main_dia-walls*2-0.8;//0.8 is cleareance 
echo("generating");
//here enter either generate= ["valve","wall","container","hinge"]
difference(){
	container(height = length, dia=main_dia, generate="hinge");
	//translate([0,0,58])cube(size=[100,100,100],center=true);
}

%translate([0,0,20])	basket(height=20,dia=basket_OD);
%translate([0,4,75])  rotate([90,0,0]) hingeLever();

//"plug" for basket
//hole_adaptor(ID=6);



//for demo only
//translate([0,0,5]) %color([0,0.5,1,0.5]) halfCircle(dia=main_dia, height=50, cutOffset=0, orient=-1);

//for testing only
//cube([100,100,27],center=true);
//translate([0,0,43]) cube([100,100,35],center=true);


