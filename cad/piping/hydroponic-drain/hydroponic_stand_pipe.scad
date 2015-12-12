// A Hydroponic drain

flange_ht     = 5;
v_thread_len  =1-((flange_ht+5)/25.4);

walls_thk     = 2;

main_dia_adju = -0.5;
main_dia      = 25 + main_dia_adju;

bottom_thread_Offset = 23-0.2 ;
bottom_thread_length = 10;
top_thread_length    = 10;

threads_length       = bottom_thread_length + top_thread_length;

total_length = threads_length + (bottom_thread_Offset - top_thread_length) ;
smooth_center_length = total_length - threads_length; 
center_hole_dia = 18;

top_inner_thread = true;
bottom_inner_thread  = true;

mm_pitch = 2;//(1.0/threads_per_inch)*25.4;

// Thread library Open Source by Dan Kirshner - dan_kirshner@yahoo.com
include <threads.scad>

module body() {
  diameter = 1.0;
  threads_per_inch = 14;
  length = v_thread_len;
  
  mm_diameter = diameter*25.4;
  
  mm_length = length*25.4;


	union () {		
		// bottom thread
		//
		translate ([0,0,bottom_thread_Offset])  metric_thread( main_dia, mm_pitch, bottom_thread_length );

		//main 
		translate ([0,0,top_thread_length]) cylinder(h=smooth_center_length,r=main_dia/2,center=false);
		//translate ([0,0,0]) #cylinder(h=total_length,r=main_dia/2);

		//top thread
		metric_thread( main_dia, mm_pitch, top_thread_length );
	}
}
module holes() {
	union () {	
		#cylinder(h=total_length+0.1,d=center_hole_dia-2);

		metric_thread( center_hole_dia, mm_pitch, top_thread_length );

	}
}

difference () {
	body();
	holes();
	
	//for testing only
	//cube([100,100,27],center=true);
	//translate([0,0,43]) cube([100,100,35],center=true);
}

