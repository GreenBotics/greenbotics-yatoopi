// A Hydroponic syphon

length=45;
main_dia= 48;
walls = 2.5;
inlets_dia=8;

body_length = length-main_dia/2;
center_hole_dia = main_dia-(walls*2);
  

module body() {
	union () {		

		cylinder(h=body_length,d=main_dia,center=false);
		translate ([0,0,body_length])  sphere(d=main_dia);
	}
}

module holes() {
	height = main_dia/2;
	union () {	
		cylinder(h=body_length,d=center_hole_dia,center=false);
		translate([0,0,body_length])  sphere(d=center_hole_dia);
		
		translate([0,0,-height/2]) cube(size=[main_dia,main_dia,height],center=true);

		//inlets
		for (a =[0:8])
		{
			rotate([0,90,360/8*a]) cylinder(h=main_dia*2,d=inlets_dia,center=true);
		}
		
	}
}

difference () {
	body();
	holes();
	
	//for testing only
	//cube([100,100,27],center=true);
	//translate([0,0,43]) cube([100,100,35],center=true);
}

