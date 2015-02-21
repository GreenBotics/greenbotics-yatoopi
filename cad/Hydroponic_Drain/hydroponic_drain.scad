// A Hydroponic drain

flange_ht     = 5;
flange_dia    = 40;
flange_max_dia= 50;

v_thread_len=1-((flange_ht+5)/25.4);

reduct        = 0.2;
walls_thk     = 2;

main_dia_adju = -0.5;
main_dia      = 25 + main_dia_adju;
main_length   = 18-reduct;//based on plank thickness
thread_length = 10;

outlet_dia    = 18;
outlet_minDia = 7.8;
outlet_height = main_length + thread_length;

spigot_ht     = 55;
spigot_dia    = 16;//based on tubing OD of 16 mm

taper_reduct  = 1.1;
taper_end_dia = 5.7;
taper_height  = 10;

hole_dia = spigot_dia - walls_thk*2;// 8.4;

// Thread library Open Source by Dan Kirshner - dan_kirshner@yahoo.com
include <threads.scad>

module body() {
  diameter = 1.0;
  threads_per_inch = 14;
  length = v_thread_len;
  
  mm_diameter = diameter*25.4;
  mm_pitch = 2;//(1.0/threads_per_inch)*25.4;
  mm_length = length*25.4;


	union () {
		// Flange
		cylinder(h=flange_ht,r1=flange_dia/2,r2=flange_max_dia/2);
		
		// 3/4" BSPP thread
		translate ([0,0,flange_ht]) {
      // smooth portion for fit
      cylinder(h=main_length,r=main_dia/2);
			translate ([0,0,main_length])  metric_thread( main_dia, mm_pitch, thread_length );
			
		}
		//spigot
		cylinder(h=spigot_ht,r=spigot_dia/2);
		
		// Base taper
		translate([0,0,outlet_height+flange_ht]) cylinder(h=taper_height,r2=spigot_dia/2,r1=main_dia/2-taper_reduct);
		
		// Spigot barb
		//translate([0,0,spigot_ht-10]) cylinder(h=8,r1=12.4/2+0.75,r2=12.4/2);
	}
}
module holes() {
	union () {
	// Central drainage hole
	translate([0,0,-1])
		cylinder(h=100+spigot_ht,r=hole_dia/2);
	// Tapered outlet
	translate ([0,0,-0.1])
		cylinder(h=outlet_height/2-0.1,r=outlet_dia/2);
	translate([0,0,outlet_height/2-0.3])
		cylinder(h=outlet_height/2,r1=outlet_dia/2,r2=outlet_minDia/2);
	}
}

difference () {
	body();
	holes();
	
	//for testing only
	//cube([100,100,27],center=true);
	//translate([0,0,43]) cube([100,100,35],center=true);
}

